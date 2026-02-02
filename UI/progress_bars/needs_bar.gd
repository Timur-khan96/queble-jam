extends TextureProgressBar
class_name NeedBar

signal clicked(type)

var type: Consts.NEED_TYPE

func _init(_my_type: Consts.NEED_TYPE):
	type = _my_type
	fill_mode = FILL_BOTTOM_TO_TOP
	texture_progress = load("uid://cgd8xglvb5lj4")
	texture_under = load("uid://c3rxcbpl8nbwe")
	texture_over = load(Consts.NEED_ICONS[type])
	max_value = 1.
	step = 0.01
	value = GameData.needs[type]
	mouse_filter = Control.MOUSE_FILTER_STOP
	
func _gui_input(event):
	if event is not InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(type)
	
		
	
