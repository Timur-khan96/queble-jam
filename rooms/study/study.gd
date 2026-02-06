extends Room

signal computer_opened()
signal computer_closed()

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

		
		
