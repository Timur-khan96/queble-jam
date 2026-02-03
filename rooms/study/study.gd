extends Room


@export var computer_scene: PackedScene
var computer_node: Node

func _on_computer_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_computer()
			
func _start_computer():
	if computer_node != null: return
	computer_node = computer_scene.instantiate()
	
	add_child(computer_node)
	computer_node.global_position = get_viewport_rect().position
	computer_node.global_position.x += 600
	
	
func _input(event):
	if computer_node == null: return
	if Input.is_action_just_pressed_by_event("exit", event):
		computer_node.queue_free()
		get_viewport().set_input_as_handled()
	if Input.is_action_just_pressed_by_event("enter", event):
		computer_node.restart_minigame()
		get_viewport().set_input_as_handled()
		
