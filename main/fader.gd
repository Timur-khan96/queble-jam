extends ColorRect

func fade_from_black(fade_time: int = 1):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 0), fade_time)
	await tween.finished
	hide()
		
func fade_to_black(fade_time: int = 1):
	show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", Color(0, 0, 0, 1), fade_time)
	await tween.finished
	return
	
