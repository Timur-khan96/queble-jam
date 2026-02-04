extends Control

signal closed()

@onready var sub_viewport = %SubViewport

@export var minigame_scene: PackedScene
var minigame_node: Node
	
func restart_minigame() -> Node:
	if minigame_node != null:
		minigame_node.queue_free()
		minigame_node = null
	minigame_node = minigame_scene.instantiate()
	sub_viewport.add_child(minigame_node)
	return minigame_node
	
func _on_close_button_pressed():
	closed.emit()
