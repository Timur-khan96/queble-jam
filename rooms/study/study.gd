extends Room


@onready var computer_root = $computer_root

@export var computer_scene: PackedScene
var computer_node: Node

func _ready():
	computer_root.position.x = get_viewport_rect().size.x / 2

func _on_computer_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_computer()
			
func _start_computer():
	if computer_node != null: return
	computer_node = computer_scene.instantiate()
	computer_root.add_child(computer_node)

	
	
func _input(event):
	if computer_node == null: return
	if Input.is_action_just_pressed_by_event("exit", event):
		computer_node.queue_free()
		get_viewport().set_input_as_handled()
	if Input.is_action_just_pressed_by_event("enter", event):
		computer_node.restart_minigame()
		get_viewport().set_input_as_handled()
		
