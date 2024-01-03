extends Area2D

# Player Collision Signal Detection
signal hit

# Settings
@export var speed = 400 # Player Speed (pixels/sec)
@export var laser_scene: PackedScene

# Variables
var score
var screen_size
var alive = true
var next_fire_time = 0 # controls the rate of fire
var fire_rate = .1 # seconds between shots


# Player collision function
func _player_body_entered(body):  # If an object enters the players collision body
	alive = false
	hide() # Player disappears after being hit.
	hit.emit() # CollisionShape2D must be deferred as we can't change physics properties on a physics callback.
	$PlayerCollision.set_deferred("disabled", true) # Turn off the collision when hit
	$ShipExplode.play()

# Game reset function
func start(pos):
	position = pos
	show()
	$PlayerCollision.disabled = false


# Fire function
func fire():
	var laser_instance_left = laser_scene.instantiate()
	var laser_instance_right = laser_scene.instantiate()
	var left_gun_position = $LeftGunPosition.global_position
	var right_gun_position = $RightGunPosition.global_position
	
	laser_instance_left.global_position = left_gun_position
	laser_instance_right.global_position = right_gun_position
	
	get_tree().root.add_child(laser_instance_left)
	get_tree().root.add_child(laser_instance_right)
	laser_instance_left.laser_sound()  # If placed before the instance is created in the root tree, error


# Ready function
func _ready():
	screen_size = get_viewport_rect().size
	alive = true

# Processes, called every frame
func _process(delta):
	var velocity = Vector2.ZERO

	if alive:  # Player controls below only function if player is alive
		var moving = false
		# Basic Movement
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
			moving = true
			
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
			moving = true
			
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
			moving = true

		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
			moving = true

		# Player Sounds
		if moving and not $EngineTurn.is_playing():
			$EngineTurn.play()
		elif not moving and $EngineTurn.is_playing():
			$EngineTurn.stop()
	
		# Animations for Player Sprites
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$MovementSprite.play()
		else:
			$MovementSprite.stop()

		# Flips animation horizontal or vertically
	#	if velocity.x != 0:
	#		animated_sprite.animation = "horizontal"
	#		animated_sprite.flip_v = false
	#		animated_sprite.flip_h = velocity.x < 0
	#	elif velocity.y != 0:
	#		animated_sprite.animation = "vertical"
	#		animated_sprite.flip_v = velocity.y > 0

		# Clamping
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)

		# Handles Primary Weapons Fire
		if Input.is_action_just_pressed("primary_fire"):
			fire()
		
		# Rapid Fire (Fast)
		if Input.is_action_pressed("primary_fire") and Time.get_ticks_msec() > next_fire_time:
			fire()
			next_fire_time = Time.get_ticks_msec() + fire_rate * 1000
			
	elif $EngineTurn.is_playing():
		$EngineTurn.stop()
