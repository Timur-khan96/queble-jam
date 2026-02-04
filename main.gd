extends Node

@onready var coins_label := %coins_label
@onready var needs_container := %needs_container
@onready var girl := $girl


var current_room_node: Room

func _ready():
	for need_type in Consts.NEED_TYPE:
		var bar = NeedBar.new(Consts.NEED_TYPE[need_type])
		needs_container.add_child(bar)
		bar.clicked.connect(_on_need_bar_clicked)
	change_room(Consts.ROOM_TYPE.BEDROOM)
	GameData.coins_updated.connect(_on_coins_updated)
	_on_coins_updated()
	_position_girl()
	
func _position_girl(centered: bool = false):
	var rect_size = girl.get_viewport_rect().size
	var x_offset_factor = 0.5 if centered else 0.75
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
	
func _connect_room_signals():
	match current_room_node.room_type:
		Consts.ROOM_TYPE.STUDY:
			current_room_node.computer_opened.connect(func(): 
				girl.hide())
			current_room_node.computer_closed.connect(func(): 
				girl.show())
		Consts.ROOM_TYPE.BATHROOM:
			current_room_node.washing_started.connect(func():
				needs_container.hide()
				girl.hide())
				#_position_girl(true)
				#girl.is_washing = true)
			current_room_node.washing_finished.connect(func():
				needs_container.show() 
				girl.show())
				#_position_girl()
				#girl.is_washing = false)
	
func _input(event):
	if Input.is_action_just_pressed_by_event("exit", event):
		get_tree().quit()
		
func _on_coins_updated():
	coins_label.text = "💰: %d" % GameData.coins
	
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
	
func _on_needs_timer_timeout():
	GameData.decrease_needs()
	if GameData.needs[Consts.NEED_TYPE.HYGIENE] < 0.5:
		girl.is_dirty = true
