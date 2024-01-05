extends RigidBody2D

signal mob_hit
signal mob_dead
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
		print("mob_dead mob_dead mob_dead mob_dead")  # Debug
		queue_free()
