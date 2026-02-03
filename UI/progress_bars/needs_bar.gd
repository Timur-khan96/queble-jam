extends TextureProgressBar
class_name NeedBar

signal clicked(type)

var type: Consts.NEED_TYPE

const OUTLINE_RADIUS = 64

var hovered = false

func _init(_my_type: Consts.NEED_TYPE):
	type = _my_type
	fill_mode = FILL_BOTTOM_TO_TOP
	texture_progress = load("uid://cgd8xglvb5lj4")
	texture_under = load("uid://c3rxcbpl8nbwe")
	texture_over = load(Consts.NEED_ICONS[type])
	max_value = 1.
	step = 0.001
	mouse_filter = Control.MOUSE_FILTER_STOP
	GameData.needs_updated.connect(_on_needs_updated)
	_update_value()
	
func _notification(what):
	if what == NOTIFICATION_MOUSE_ENTER:
		hovered = true
		queue_redraw()
	elif what == NOTIFICATION_MOUSE_EXIT:
		hovered = false
		queue_redraw()
	
func _draw():
	if !hovered: return
	var pos = size / 2
	draw_circle(pos, OUTLINE_RADIUS, Color.WHITE, false, 4.0)
	
func _gui_input(event):
	if event is not InputEventMouseButton: return
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		clicked.emit(type)
		
func _on_needs_updated():
	_update_value()
	
func _update_value():
	value = GameData.needs[type]
	if value > 0.5:
		tint_progress = Color.FOREST_GREEN
	elif value > 0.25:
		tint_progress = Color.YELLOW
	else:
		tint_progress = Color.RED
		
		
	
		
	
