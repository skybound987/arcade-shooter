extends Area2D

var speed = 1050

func _ready():
	pass

func _physics_process(delta):
	var y_vector = transform.y
	position -= y_vector * speed * delta
	
func _on_Laser_body_entered(body):
#	if body.is_in_group("Mob"):
#		body.emit_signal("mob_hit")
#		if body.emit_signal("mob_hit"):
#			print("Mob signal is going out!!!!!!")
	#	$MobDeath.play()
	#	body.queue_free()
	queue_free()
	
func laser_sound():
	$LaserSound.play()
