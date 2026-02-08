extends Room

@onready var canceling_control = $canceling_control

@export var fridge_ui_scene: PackedScene
var fridge_ui: Control

func _ready():
	super._ready()
	canceling_control.mouse_entered.connect(_on_canceling_control_mouse_entered)

func toggle_fridge_ui():
	if fridge_ui == null:
		fridge_ui = fridge_ui_scene.instantiate()
		add_child(fridge_ui)
		$fridge_stream.play()
		fridge_ui.crunch.connect($crunch_stream.play)
		fridge_ui.buy.connect($buy_stream.play)
		fridge_ui.global_position = $fridge_marker.global_position
	else:
		fridge_ui.queue_free()
		fridge_ui = null
	
func _on_canceling_control_mouse_entered():
	if fridge_ui:
		toggle_fridge_ui()

func _on_background_pressed():
	toggle_fridge_ui()
