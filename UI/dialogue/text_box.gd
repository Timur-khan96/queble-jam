extends MarginContainer

signal finished_display()

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 768
const letter_time = 0.03
const space_time = 0.06
const punctuation_time = 0.2


var text := ""
var char_index := 0

func display_text(new_text: String):
	text = new_text
	label.text = text
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized #await for x resize
		await resized #await for y resize
		custom_minimum_size.y = size.y
	#global_position.x -= size.x / 2
	#global_position.y -= size.y + 24
	label.text = ""
	_display_letter()
	
func _display_letter():
	label.text += text[char_index]
	char_index += 1
	if char_index >= text.length():
		finished_display.emit()
		return
		
	match text[char_index]:
		"!", "?", ".", ",", ";", ":", "(", ")":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
