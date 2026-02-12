extends MarginContainer

signal finished_display(bool)

@onready var label = %Label
@onready var timer = $LetterDisplayTimer

var MAX_WIDTH = 768
const letter_time = 0.03
const space_time = 0.06
const punctuation_time = 0.2
const anomaly := AnomalyServer.ANOMALY.SPEECH

var is_anomaly: bool = false

var text := ""
var char_index := 0

func _ready():
	MAX_WIDTH = get_viewport_rect().size.x / 2.5

func apply_anomaly():
	is_anomaly = true
	add_to_group("reportable_anomaly")

func revert_anomaly():
	is_anomaly = false
	remove_from_group("reportable_anomaly")
	hide()
	finished_display.emit(true)

func display_text(new_text: String):
	if AnomalyServer.current_anomalies[anomaly]:
		apply_anomaly()
		if OS.has_feature("web"):
			new_text = Consts.cursed_phrases_html_friendly.pick_random()
		else:
			new_text = Cursed.cursed_phrases.pick_random()
	text = new_text
	label.text = text
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		if is_anomaly and !OS.has_feature("web"):
			label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		else:
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
			finished_display.emit(false)
		return
		
	match text[char_index]:
		"!", "?", ".", ",", ";", ":", "(", ")":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
