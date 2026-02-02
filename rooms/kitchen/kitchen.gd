extends Room

@export var fridge_ui_scene: PackedScene
var fridge_ui: Control

func toggle_fridge_ui():
	if fridge_ui == null:
		var mouse_pos = get_global_mouse_position()
		fridge_ui = fridge_ui_scene.instantiate()
		add_child(fridge_ui)
		fridge_ui.global_position = mouse_pos
	else:
		fridge_ui.queue_free()
		fridge_ui = null

func _on_fridge_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			toggle_fridge_ui()
