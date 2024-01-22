extends RigidBody2D

# Player Collision Signal Detection
signal hit

# Settings
@export var laser_scene: PackedScene

# Variables
@export var speed = 400 # Player Speed (pixels/sec)
var score
var screen_size
var health = 5
var alive = true
var next_fire_time = 0 # controls the rate of fire
var fire_rate = .1 # seconds between shots
var max_speed: float = 400.0
var thrust = Vector2(0, -450)
var torque = 2500



func _player_body_entered(body):  # If an object enters the players collision body
	print("Player Hit!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	_player_damage()

func _player_dead():
	alive = false
	$ShipExplode.play()
	hide() # Player disappears after being hit.
#	hit.emit() # CollisionShape2D must be deferred as we can't change physics properties on a physics callback.
	$PlayerCollision.set_deferred("disabled", true) # Turn off the collision when hit

func _player_damage(hit_points = 1):
	$ShipDamage.play()
	health -= hit_points
	print("Damage Damage Damage")
	if health <= 0:
		_player_dead()


# Game reset function
func start(pos):
	position = pos
	show()
	$PlayerCollision.disabled = false


# Fire function
func fire():
	var laser_instance_left = laser_scene.instantiate()    #  Holds laser instance for spawning
	var laser_instance_right = laser_scene.instantiate()
	get_tree().root.add_child(laser_instance_left)         #  Add instance to the scene tree
	get_tree().root.add_child(laser_instance_right)
	laser_instance_left.transform = $LeftGunPosition.global_transform    #  Assign transform to allow rotation
	laser_instance_right.transform = $RightGunPosition.global_transform	
	laser_instance_left.laser_sound() 
	


# Called once at start
func _ready():
	screen_size = get_viewport_rect().size
	alive = true

# Called every frame
func _physics_process(delta):
	var velocity: Vector2 = Vector2.ZERO
	
	if alive:  # Player controls below only function if player is alive
		var moving = false	
#		if velocity.length() > max_speed:  # Caps max speed
#			velocity = velocity.normalized() * max_speed
		
		# Player Sounds
		if moving and not $EngineTurn.is_playing():
			$EngineTurn.play()
		elif not moving and $EngineTurn.is_playing():
			$EngineTurn.stop()

		# Animations for Player Sprites
#		if velocity.length() > 0:
#			velocity = velocity.normalized() * speed
#			$MovementSprite.play()
#		else:
#			$MovementSprite.stop()

		# Flips animation horizontal or vertically
	#	if velocity.x != 0:
	#		animated_sprite.animation = "horizontal"
	#		animated_sprite.flip_v = false
	#		animated_sprite.flip_h = velocity.x < 0
	#	elif velocity.y != 0:
	#		animated_sprite.animation = "vertical"
	#		animated_sprite.flip_v = velocity.y > 0

#		# Clamping
#		position += velocity * delta
#		position = position.clamp(Vector2.ZERO, screen_size)

		# Handles Primary Weapons Fire
#		if Input.is_action_just_pressed("primary_fire"):
#			fire()

		# Rapid Fire (Fast)
		if Input.is_action_pressed("primary_fire") and Time.get_ticks_msec() > next_fire_time:
			fire()
			next_fire_time = Time.get_ticks_msec() + fire_rate * 1000

	elif $EngineTurn.is_playing():
		$EngineTurn.stop()

func _integrate_forces(state):    # More physics control and options compared to _physics_process()
	
	var rotation_direction = 0
	var contact_count = get_contact_count()
	
	if Input.is_action_pressed("move_up"):    # Thrust input
		state.apply_force(thrust.rotated(rotation))
	else:
		state.apply_force(Vector2())
		
	if Input.is_action_pressed("move_right"):    # Rotation input
		rotation_direction += 1
	if Input.is_action_pressed("move_left"):
		rotation_direction -= 1
		
	state.apply_torque(rotation_direction * torque)  #  Enables the movement to happen
	
