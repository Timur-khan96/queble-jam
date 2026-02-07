extends Node
class_name RoomManager

signal day_finished()
signal girl_screamer_request()

var girl: TextureRect
var h_needs_container: HBoxContainer
var v_needs_container:VBoxContainer

var current_room_node: Room

var walk_stream: AudioStreamPlayer

func _init(_girl, h_needs, v_needs):
	girl = _girl
	h_needs_container = h_needs
	v_needs_container = v_needs
	walk_stream = AudioStreamPlayer.new()
	walk_stream.stream = load("uid://b2kdumeigyf36")
	walk_stream.bus = &"FX"
	add_child(walk_stream)

func _ready():
	for need_type in Consts.NEED_TYPE:
		var bar = NeedBar.new(Consts.NEED_TYPE[need_type])
		h_needs_container.add_child(bar)
		bar.clicked.connect(_on_need_bar_clicked)
	change_room(Consts.ROOM_TYPE.BEDROOM)
	
func change_room(new_room: Consts.ROOM_TYPE):
	if current_room_node != null:
		if new_room == current_room_node.room_type: return
		current_room_node.queue_free()
		current_room_node = null
		walk_stream.play()
	
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
	current_room_node.girl_screamer_request.connect(girl_screamer_request.emit)
	match current_room_node.room_type:
		Consts.ROOM_TYPE.BEDROOM:
			current_room_node.sleep_started.connect(day_finished.emit)
		Consts.ROOM_TYPE.STUDY:
			_connect_study()
		Consts.ROOM_TYPE.BATHROOM:
			_connect_bathroom()
			
			
func _connect_study():
	current_room_node.computer_opened.connect(func(): 
		_move_needs_left()
		girl.hide())
	current_room_node.computer_closed.connect(func():
		_move_needs_bottom()
		girl.show())
				
func _connect_bathroom():
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
