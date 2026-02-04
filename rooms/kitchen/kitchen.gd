extends Room

@onready var canceling_control = $canceling_control
@onready var background = $background

@export var fridge_ui_scene: PackedScene
var fridge_ui: Control

func _ready():
	super._ready()
	canceling_control.mouse_entered.connect(_on_canceling_control_mouse_entered)

func toggle_fridge_ui():
	if fridge_ui == null:
		fridge_ui = fridge_ui_scene.instantiate()
		add_child(fridge_ui)
		fridge_ui.global_position = %fridge.global_position
	else:
		fridge_ui.queue_free()
		fridge_ui = null
	
func _on_canceling_control_mouse_entered():
	if fridge_ui:
		toggle_fridge_ui()

func _on_fridge_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			toggle_fridge_ui()
