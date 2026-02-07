extends TextureRect

signal girl_scream()

signal finished_talking()

const anomaly := AnomalyServer.ANOMALY.GIRL

@onready var blink_timer = $blink_timer
@onready var dirt = $dirt

var text_box_scene = load("uid://cmia4cmc7c54s")
var text_box: Control

var textures: Dictionary[String, Texture2D] = {
	"closed_eyes_closed_mouth" : load("uid://do3mnunq5e1we"),
	"closed_eyes_open_mouth" : load("uid://com1b61n30y2n"),
	"open_eyes_closed_mouth" : load("uid://dkq186kkjdit7"),
	"open_eyes_open_mouth" : load("uid://bxpqglhpf6cg3"),
	"anomaly" : load("uid://css6fhexa8mm2")}
	
var is_blinking: bool = false
var is_anomaly: bool = false:
	set(value):
		if is_anomaly == value: return
		is_anomaly = value
		if is_anomaly:
			texture = textures["anomaly"]
			get_tree().create_timer(5.0).timeout.connect(_on_girl_scream)
		else:
			_update_main_texture()

var is_talking: bool = false:
	set(value):
		if is_talking == value: return
		is_talking = value
		_update_main_texture()

var is_dirty: bool = false:
	set(value):
		if is_dirty == value: return
		is_dirty = value
		dirt.visible = is_dirty
		
func _ready():
	AnomalyServer.anomalies_reset.connect(func():
		if AnomalyServer.current_anomalies[AnomalyServer.ANOMALY.GIRL]:
			apply_anomaly())
			
func apply_anomaly():
	is_anomaly = true
	add_to_group("reportable_anomaly")

func revert_anomaly():
	is_anomaly = false
	remove_from_group("reportable_anomaly")
		
func _update_main_texture():
	if is_anomaly: return
	if is_talking:
		if is_blinking:
			texture = textures["closed_eyes_open_mouth"]
		else:
			texture = textures["open_eyes_open_mouth"]
	else:
		if is_blinking:
			texture = textures["closed_eyes_closed_mouth"]
		else:
			texture = textures["open_eyes_closed_mouth"]
		
func say(text: String):
	if is_talking or is_anomaly: return
	is_talking = true
	text_box = text_box_scene.instantiate()
	add_child(text_box)
	text_box.global_position.x -= text_box.MAX_WIDTH * 0.5
	text_box.global_position.y += 128
	text_box.display_text(text)
	text_box.finished_display.connect(_on_text_box_finished)
	
func _on_text_box_finished():
	await get_tree().create_timer(1.0).timeout
	text_box.queue_free()
	text_box = null
	is_talking = false
	finished_talking.emit()
	
func _on_blink_timer_timeout():
	is_blinking = true
	_update_main_texture()
	await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
	is_blinking = false
	_update_main_texture()
	blink_timer.start(randf_range(3, 6))
	
func _on_girl_scream():
	if is_anomaly:
		girl_scream.emit()
