extends RigidBody2D

signal mob_hit  # This signal is connected from Laser.gd and emits when the laser collides with mob
signal mob_dead  # This signal connects _mob_body_entered() to the main script
var alive = true

func _ready():
	var mob_types = $MobSprite.sprite_frames.get_animation_names()
	$MobSprite.play(mob_types[randi() % mob_types.size()])

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _mob_body_entered():
	if alive:
		alive = false
		emit_signal("mob_dead")
#		print("mob_dead mob_dead mob_dead mob_dead")  # Debug
		queue_free()
