extends Control


@onready var label = %Label
@onready var timer = $LetterDisplayTimer

const letter_time = 0.03
const space_time = 0.06
const punctuation_time = 0.2

var text := ""
var char_index := 0

func _ready():
	display_text()

func display_text():
	text = label.text
	label.text = ""
	_display_letter()
	
func _display_letter():
	label.text += text[char_index]
	char_index += 1
	if char_index >= text.length():
		return
		
	match text[char_index]:
		"!", "?", ".", ",", ";", ":", "(", ")":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			
func _input(event):
	if Input.is_action_just_pressed_by_event("exit", event):
		get_tree().quit()
	if Input.is_action_just_pressed_by_event("enter", event):
		if OS.has_feature("web"):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
