extends Room

signal sleep_started

const sleep_refusals: Array[String] = ["I don't want to sleep!",
"Rest is for the dead!", "There's stuff to do today.", "I'm not tired yet."]

func _ready():
	super._ready()
	_update_calendar()
	GameData.day_updated.connect(_update_calendar)
	
func _update_calendar():
	%day_label.text = str(GameData.day)

func _on_bed_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _can_sleep():
				sleep_started.emit()
			else:
				girl_say_request.emit(sleep_refusals.pick_random())
				
func _can_sleep():
	for n in GameData.needs:
		if n == Consts.NEED_TYPE.ENERGY:
			if GameData.needs[n] > 0.5: return false
			else: continue
		if GameData.needs[n] < 0.8: return false
	return true
