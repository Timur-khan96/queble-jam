extends Control
class_name Room

@warning_ignore("unused_signal")
signal girl_say_request(String)

var room_type: Consts.ROOM_TYPE
var need_type: Consts.NEED_TYPE

func _ready():
	match room_type:
		Consts.ROOM_TYPE.STUDY:
			need_type = Consts.NEED_TYPE.FUN
		Consts.ROOM_TYPE.KITCHEN:
			need_type = Consts.NEED_TYPE.HUNGER
		Consts.ROOM_TYPE.BATHROOM:
			need_type = Consts.NEED_TYPE.HYGIENE
		Consts.ROOM_TYPE.BEDROOM:
			need_type = Consts.NEED_TYPE.ENERGY
	#get_node("background").size = get_viewport_rect().size
