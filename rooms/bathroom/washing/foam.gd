extends Area2D

var touched: bool = false
const fall_speed:= 600


func _on_area_entered(area: Area2D):
	if touched: return
	if !area.is_in_group("shower"): return
	touched = true
	var end_y = global_position.y + 1200
	var distance = end_y - global_position.y
	var duration = distance / fall_speed

	var tween = create_tween()
	tween.tween_property(self, "global_position",
		Vector2(global_position.x, end_y),duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	tween.finished.connect(queue_free)
		
