extends Control

signal closed()

@onready var sub_viewport = %SubViewport
@onready var fun_timer = $fun_timer

@export var minigame_scene: PackedScene
var minigame_node: Node

func _ready():
	_restart_minigame()
	
func _restart_minigame():
	if minigame_node != null:
		minigame_node.queue_free()
		minigame_node = null
	minigame_node = minigame_scene.instantiate()
	minigame_node.game_over.connect(_on_minigame_over)
	minigame_node.restart_pressed.connect(_restart_minigame)
	fun_timer.start()
	sub_viewport.add_child(minigame_node)
	
func _on_close_button_pressed():
	closed.emit()
	
func _input(event):
	if Input.is_action_just_pressed_by_event("enter", event):
		_restart_minigame()
		get_viewport().set_input_as_handled()
		
func _on_minigame_over():
	fun_timer.stop()

func _on_fun_timer_timeout():
	GameData.update_need(Consts.NEED_TYPE.FUN, Consts.FUN_INCREASE_RATE)
