extends Node
class_name RoomManager

var girl: Sprite2D
var h_needs_container: HBoxContainer
var v_needs_container:VBoxContainer

var current_room_node: Room

func _init(_girl, h_needs, v_needs):
	girl = _girl
	h_needs_container = h_needs
	v_needs_container = v_needs

func _ready():
	for need_type in Consts.NEED_TYPE:
		var bar = NeedBar.new(Consts.NEED_TYPE[need_type])
		h_needs_container.add_child(bar)
		bar.clicked.connect(_on_need_bar_clicked)
	change_room(Consts.ROOM_TYPE.BEDROOM)
	_position_girl()
	
func _position_girl():
	var rect_size = girl.get_viewport_rect().size
	var x_offset_factor = 0.75
	girl.position.x = rect_size.x * x_offset_factor
	girl.position.y = rect_size.y - girl.texture.get_height() * girl.scale.y / 2
	
func change_room(new_room: Consts.ROOM_TYPE):
	if current_room_node != null:
		if new_room == current_room_node.room_type: return
		current_room_node.queue_free()
		current_room_node = null
	girl.show()
	current_room_node = load(Consts.ROOM_SCENES[new_room]).instantiate()
	current_room_node.room_type = new_room
	add_child(current_room_node)
	
	_connect_room_signals()
	
func _move_needs_left():
	for c in h_needs_container.get_children():
		c.disabled = true
		c.reparent(v_needs_container)
		
func _move_needs_bottom():
	for c in v_needs_container.get_children():
		c.disabled = false
		c.reparent(h_needs_container)
	
func _connect_room_signals():
	current_room_node.girl_say_request.connect(func(text): girl.say(text))
	match current_room_node.room_type:
		Consts.ROOM_TYPE.STUDY:
			current_room_node.computer_opened.connect(func(): 
				_move_needs_left()
				girl.hide())
			current_room_node.computer_closed.connect(func():
				_move_needs_bottom()
				girl.show())
		Consts.ROOM_TYPE.BATHROOM:
			current_room_node.washing_started.connect(func():
				_move_needs_left()
				girl.hide())
			current_room_node.washing_closed.connect(func():
				_move_needs_bottom()
				girl.show()
				girl.is_dirty = false)
	
func _on_need_bar_clicked(need_type: Consts.NEED_TYPE):
	match need_type:
		Consts.NEED_TYPE.FUN:
			change_room(Consts.ROOM_TYPE.STUDY)
		Consts.NEED_TYPE.HUNGER:
			change_room(Consts.ROOM_TYPE.KITCHEN)
		Consts.NEED_TYPE.HYGIENE:
			change_room(Consts.ROOM_TYPE.BATHROOM)
		Consts.NEED_TYPE.ENERGY:
			change_room(Consts.ROOM_TYPE.BEDROOM)
