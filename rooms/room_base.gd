extends Control
class_name Room

@warning_ignore("unused_signal")
signal girl_say_request(String)
@warning_ignore("unused_signal")
signal girl_screamer_request()

@onready var background = $background

var room_type: Consts.ROOM_TYPE

func _ready():
	background.mouse_entered.connect(_on_background_mouse_entered)
	background.mouse_exited.connect(_on_background_mouse_exited)

func _on_background_mouse_entered():
	background.material.set_shader_parameter("hovered", true)

func _on_background_mouse_exited():
	background.material.set_shader_parameter("hovered", false)
