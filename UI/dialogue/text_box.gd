extends MarginContainer

signal finished_display()

@onready var label = %Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 768
const letter_time = 0.03
const space_time = 0.06
const punctuation_time = 0.2
const anomaly := AnomalyServer.ANOMALY.SPEECH

var is_anomaly: bool = false

var text := ""
var char_index := 0

func apply_anomaly():
	is_anomaly = true
	add_to_group("reportable_anomaly")

func revert_anomaly():
	is_anomaly = false
	remove_from_group("reportable_anomaly")
	hide()
	get_tree().create_timer(1.0).timeout.connect(func():
		show()
		char_index = 0
		display_text("I don't remember what I wanted to say"))

func display_text(new_text: String):
	if AnomalyServer.current_anomalies[anomaly]:
		apply_anomaly()
		new_text = Cursed.cursed_phrases.pick_random()
	text = new_text
	label.text = text
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized #await for x resize
		await resized #await for y resize
		custom_minimum_size.y = size.y
	label.text = ""
	_display_letter()
	
func _display_letter():
	label.text += text[char_index]
	char_index += 1
	if char_index >= text.length():
		if !is_anomaly:
			finished_display.emit()
		return
		
	match text[char_index]:
		"!", "?", ".", ",", ";", ":", "(", ")":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
