extends TextureButton

@onready var cooldown_progress = $cooldown_progress


const COOLDOWN := 4.0
var accumulator: float = 0.

func _ready():
	cooldown_progress.hide()

func _pressed():
	disabled = true
	cooldown_progress.show()
	cooldown_progress.value = cooldown_progress.max_value
	
func _process(delta):
	if disabled == false: return
	accumulator += delta
	if accumulator >= COOLDOWN:
		disabled = false
		cooldown_progress.hide()
		accumulator = 0.
	else:
		cooldown_progress.value = 1. - accumulator / COOLDOWN
