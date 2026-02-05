extends ColorRect

@onready var day_label = $day_label
signal fade_out_finished()

func _ready():
	day_label.modulate = Color(0,0,0,0)

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 0), 1)
	await tween.finished
	hide()
	fade_out_finished.emit()
		
func fade_in():
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
func change_day():
	await fade_in()
	await show_day()
	fade_out()
	
