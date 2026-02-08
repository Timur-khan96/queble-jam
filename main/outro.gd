extends Control

@onready var label = $Label
@onready var color_rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color.WHITE, 1)
	tween.tween_property(label, "modulate", Color.WHITE, 1)
	
