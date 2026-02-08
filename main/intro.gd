extends Control

var main_scene: PackedScene = load("uid://d2bayih11h1pi")

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(main_scene)
	
func _input(event):
	if Input.is_action_just_pressed_by_event("exit", event):
		get_tree().quit()
	if Input.is_action_just_pressed_by_event("enter", event):
		if OS.has_feature("web"):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
