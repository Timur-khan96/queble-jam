extends Control

var main_scene: PackedScene = load("uid://d2bayih11h1pi")

func _on_start_button_pressed():
	get_tree().change_scene_to_packed(main_scene)
