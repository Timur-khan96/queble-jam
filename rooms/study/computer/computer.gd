extends Control

@onready var sub_viewport = %SubViewport

@export var minigame_scene: PackedScene
var minigame_node: Node

func _ready():
	restart_minigame()
	
func restart_minigame():
	if minigame_node != null:
		minigame_node.queue_free()
		minigame_node = null
	minigame_node = minigame_scene.instantiate()
	sub_viewport.add_child(minigame_node)
