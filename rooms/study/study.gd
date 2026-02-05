extends Room

signal computer_opened()
signal computer_closed()

@onready var fun_timer = $fun_timer

@export var computer_scene: PackedScene
var computer_node: Node

func _ready():
	super._ready()

func _on_computer_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_computer()
			
func _start_computer():
	if computer_node != null: 
		push_error("Trying to start existing computer")
		return
	computer_node = computer_scene.instantiate()
	computer_node.closed.connect(_close_computer)
	add_child(computer_node)
	_restart_minigame()
	computer_opened.emit()
	
func _close_computer():
	if computer_node == null:
		push_error("Trying to close null computer")
		return
	computer_node.queue_free()
	computer_node = null
	computer_closed.emit()

func _input(event):
	if computer_node == null: return
	if Input.is_action_just_pressed_by_event("exit", event):
		_close_computer()
		get_viewport().set_input_as_handled()
	if Input.is_action_just_pressed_by_event("enter", event):
		_restart_minigame()
		get_viewport().set_input_as_handled()
		
func _restart_minigame():
	if computer_node == null:
		push_error("trying to restart the mini game on null computer")
		return
	var minigame = computer_node.restart_minigame()
	minigame.game_over.connect(_on_minigame_over)
	fun_timer.start()
		
func _on_fun_timer_timeout():
	if computer_node == null:
		fun_timer.stop()
	else:
		GameData.update_need(need_type, Consts.FUN_INCREASE_RATE)
		
func _on_minigame_over():
	fun_timer.stop()

		
		
