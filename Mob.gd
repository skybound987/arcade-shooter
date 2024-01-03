extends RigidBody2D

signal mob_hit
var alive = true

func _ready():
	var mob_types = $MobSprite.sprite_frames.get_animation_names()
	$MobSprite.play(mob_types[randi() % mob_types.size()])

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _mob_body_entered(body):
	mob_hit.emit()
#	score += 1
#	$HUD.update_score(score)
	queue_free()
