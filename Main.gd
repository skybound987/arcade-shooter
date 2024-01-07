extends Node

@export var mob_scene: PackedScene

var score = 0  # initializes score to zero

func game_over():
	$MobTimer.stop()
	$ScoreTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
#	$GameStart.play()
#	$Level1.play()

func _on_score_timer_timeout():
#	score += 1
#	$HUD.update_score(score)
#	print(score)
	pass

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():  # Handles mob spawning
	# Creates a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Chooses a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Sets the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Sets the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Adds some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Chooses the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	mob.mob_dead.connect(Callable(self, "mob_death"))
	
	# Spawns the mob by adding it to the Main scene.
	add_child(mob)

func mob_death():
	$MobDeath.play()
	score += 1
	$HUD.update_score(score)
#	print("Score +1 - Score Updated!!!!!")

func _ready():
	new_game()

func _process(delta):
	pass
