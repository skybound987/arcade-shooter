extends CanvasLayer

var hit_points = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	floating_combat_damage(hit_points)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func floating_combat_damage(hit_points, duration = 1.0):
	$Damage.text = str(hit_points)
	# Example animation: move up and fade out
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property($Damage, "rect_position", $Damage.rect_position, $Damage.rect_position + Vector2(0, -50), duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property($Damage, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	await tween.tween_all_completed()
	queue_free()  # Or hide for reuse
