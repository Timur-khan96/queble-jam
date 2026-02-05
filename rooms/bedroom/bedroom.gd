extends Room

signal sleep_started

const sleep_refusals: Array[String] = ["I don't want to sleep!",
"Rest is for the dead", "There's stuff to do today"]

func _ready():
	super._ready()

func _on_bed_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if _can_sleep():
				girl_say_request.emit("I had a wonderful day!")
				sleep_started.emit()
			else:
				girl_say_request.emit(sleep_refusals.pick_random())
				
func _can_sleep():
	for n in GameData.needs:
		if n == Consts.NEED_TYPE.ENERGY:
			if GameData.needs[n] > 0.5: return false
			else: continue
		if GameData.needs[n] < 0.5: return false
	return true
