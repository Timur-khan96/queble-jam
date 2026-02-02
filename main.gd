extends Node2D

@onready var coins_label = %coins_label
@onready var needs_container = %needs_container

var current_room_node

func _ready():
	for need_type in Consts.NEED_TYPE:
		var bar = NeedBar.new(Consts.NEED_TYPE[need_type])
		needs_container.add_child(bar)
		
func _process(_delta):
	coins_label.text = "💰: %d" % GameData.coins
	

			
			
