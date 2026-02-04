extends Room

signal washing_started
signal washing_finished

var washing_node: Control

func _on_bath_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_start_washing()
			
func _start_washing():
	if washing_node != null:
		push_error("Trying to start washing with existing washing node")
		return
	washing_node = load(Consts.WASHING_SCENE_UID).instantiate()
	add_child(washing_node)
	washing_node.closed.connect(_finish_washing)
	washing_started.emit()
	
func _finish_washing():
	if washing_node == null:
		push_error("Trying to finish null washing")
		return
	washing_node.queue_free()
	washing_node = null
	washing_finished.emit()
	
func _input(event):
	if washing_node == null: return
	if Input.is_action_just_pressed_by_event("exit", event):
		_finish_washing()
		get_viewport().set_input_as_handled()
			
