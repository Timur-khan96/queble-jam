extends ColorRect

@onready var day_label = $day_label

func _ready():
	day_label.modulate = Color(0,0,0,0)

func fade_from_black(fade_time: int = 1):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 0), fade_time)
	await tween.finished
	hide()
		
func fade_to_black():
	show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 1), 1)
	await tween.finished
	return
		
#not used
func show_day():
	day_label.text = "Day %d" % GameData.day
	var tween = get_tree().create_tween()
	tween.tween_property(day_label, "modulate", Color(1,1,1,1), 1)
	tween.tween_property(day_label, "modulate", Color(0,0,0,0), 1)
	await tween.finished

#not used
#func change_day():
	#await fade_in()
	#await show_day()
	#fade_out()
	
