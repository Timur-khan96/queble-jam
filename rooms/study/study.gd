extends Room

signal computer_opened()
signal computer_closed()

@export var computer_scene: PackedScene
var computer_node: Node

@onready var audio = $AudioStreamPlayer
var computer_on_stream: AudioStream = load("uid://oertmbi6ab0p")
var computer_off_stream: AudioStream = load("uid://dff75vkkeq820")

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
	audio.stream = computer_on_stream
	audio.play()
	computer_node = computer_scene.instantiate()
	computer_node.closed.connect(_close_computer)
	add_child(computer_node)
	computer_opened.emit()
	
func _close_computer():
	if computer_node == null:
		push_error("Trying to close null computer")
		return
	if computer_node.minigame_node:
		GameData.update_coins(computer_node.minigame_node.score)
	audio.stream = computer_off_stream
	audio.play()
	computer_node.queue_free()
	computer_node = null
	computer_closed.emit()

func _input(event):
	if computer_node == null: return
	if Input.is_action_just_pressed_by_event("exit", event):
		_close_computer()
		get_viewport().set_input_as_handled()

		
		
