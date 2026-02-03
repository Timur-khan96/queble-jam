extends Node

@onready var coins_label = %coins_label
@onready var needs_container = %needs_container

var current_room_node: Room

func _ready():
	for need_type in Consts.NEED_TYPE:
		var bar = NeedBar.new(Consts.NEED_TYPE[need_type])
		needs_container.add_child(bar)
		bar.clicked.connect(_on_need_bar_clicked)
	change_room(Consts.ROOM_TYPE.BEDROOM)
	GameData.coins_updated.connect(_on_coins_updated)
	_on_coins_updated()
	
func change_room(new_room: Consts.ROOM_TYPE):
	if current_room_node != null:
		if new_room == current_room_node.room_type: return
		current_room_node.queue_free()
		current_room_node = null
	current_room_node = load(Consts.ROOM_SCENES[new_room]).instantiate()
	current_room_node.room_type = new_room
	add_child(current_room_node)
		
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
