using Godot;

public partial class Laser : Area2D
{
    private float speed = 1050;

    public override void _Ready()
    {
        // Initialization code here, if any
    }

// _PhysicsProcess:  Called 60 times per second by default, highly accurate, taxing
// _Process: Called every frame, smooth, not accurate or taxing
    public override void _PhysicsProcess(double delta) // Trying _PhysicsProcess instead of _Process because its a projectile
    {
      Vector2 yVector = Transform.Y;
      Position -= yVector * speed * (float)delta;
    }

    private void _on_Laser_body_entered(Node body)
    {
      if (body.IsInGroup("Mob"))
      {
        body.QueueFree();
      }
      QueueFree();
    }
}
