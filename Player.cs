using Godot;

public partial class Player : Area2D
{
  // Collision Detection
  [Signal]
  public delegate void HitEventHandler();

  private bool Alive = true;

  private void OnBodyEntered(Node2D body)
  {
    Alive = false;
    Hide(); // Player disappears after being hit.
    EmitSignal(SignalName.Hit); // CollisionShape2D must be deferred as we can't change physics properties on a physics callback.
    GetNode<CollisionShape2D>("CollisionShape2D").SetDeferred(CollisionShape2D.PropertyName.Disabled, true); // Gotta turn off the collision when hit, otherwise it will continually trigger hits
  }

  // Resets player to New Game when dead
  public void Start(Vector2 position)
  {
    Position = position;
    Show();
    GetNode<CollisionShape2D>("CollisionShape2D").Disabled = false;
  }

  // Settings
  [Export]  // Player Speed
  public int Speed { get; set; } = 400; // How fast the player will move (pixels/sec).

  [Export]  // Laser Projectile
  public PackedScene LaserScene { get; set; }

  private void Fire()
  {
    GD.Print("Attempting Fire");  // debug
    if (LaserScene != null)
    {
      GD.Print("LaserScene is not null");  // debug
      Laser laserInstanceLeft = LaserScene.Instantiate<Laser>();
      Laser laserInstanceRight = LaserScene.Instantiate<Laser>();
      if (laserInstanceLeft != null)
      {
        Marker2D LeftGunPosition = GetNode<Marker2D>("LeftGunPosition");
        Marker2D RightGunPosition = GetNode<Marker2D>("RightGunPosition");
        GD.Print("LeftGunPosition is " + LeftGunPosition.GlobalPosition);
        GD.Print("RightGunPosition is " + RightGunPosition.GlobalPosition);
        laserInstanceLeft.GlobalPosition = LeftGunPosition.GlobalPosition;
        laserInstanceRight.GlobalPosition = RightGunPosition.GlobalPosition;
        GetTree().Root.AddChild(laserInstanceLeft);
        GetTree().Root.AddChild(laserInstanceRight);
      }
    }
    else
    {
      GD.Print("LaserScene is null...");
    }
  }


  public Vector2 ScreenSize; // Size of the game window.

  // Ready function, Staging room for initialization, called once for each node and its children entering the scene tree
  public override void _Ready()
  {
    ScreenSize = GetViewportRect().Size;
  }

  // Processes, called every frame
	public override void _Process(double delta)
  {
    var velocity = Vector2.Zero; // The player's movement vector.
    
    var animatedSprite2D = GetNode<AnimatedSprite2D>("AnimatedSprite2D");

    if (Alive)  // If the player is alive, allow these inputs, else return nothing.
    {           // Prevents player input after death
      // Basic Movement
      if (Input.IsActionPressed("move_right"))
      {
        velocity.X += 1;
      }

      if (Input.IsActionPressed("move_left"))
      {
        velocity.X -= 1;
      }

      if (Input.IsActionPressed("move_down"))
      {
        velocity.Y += 1;
      }

      if (Input.IsActionPressed("move_up"))
      {
        velocity.Y -= 1;
      }
      
      // Animations for Player Sprites
      if (velocity.Length() > 0)  
      {
        velocity = velocity.Normalized() * Speed;  // Normalized Movement for Diagnol movement
        animatedSprite2D.Play();
      }
      else
      {
        animatedSprite2D.Stop();
      }

      // Flips animation horizontal or vertically
      if (velocity.X != 0)
      {
        animatedSprite2D.Animation = "horizontal";
        animatedSprite2D.FlipV = false;
        animatedSprite2D.FlipH = velocity.X < 0;
      }
      else if (velocity.Y != 0)
      {
        animatedSprite2D.Animation = "vertical";
        animatedSprite2D.FlipV = velocity.Y > 0;
      }

      // Clamping, prevents moving outside of screen boundary
      Position += velocity * (float)delta;  
      Position = new Vector2(
        x: Mathf.Clamp(Position.X, 0, ScreenSize.X),
        y: Mathf.Clamp(Position.Y, 0, ScreenSize.Y)
      );

      //  Handles Primary Weapons Fire
      if (Input.IsActionJustPressed("primary_fire"))
      {
        GD.Print("Fire");
        Fire();
      }
    }  
    else
    {
      return;
    }
  }
}

