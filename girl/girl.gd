extends TextureRect

signal girl_scream()
signal finished_talking()

var anomaly: AnomalyServer.ANOMALY

@onready var blink_timer = $blink_timer
@onready var dirt = $dirt
@onready var anomaly_timer = $anomaly_timer


var text_box_scene = load("uid://cmia4cmc7c54s")
var text_box: Control

var textures: Dictionary[String, Texture2D] = {
	"closed_eyes_closed_mouth" : load("uid://do3mnunq5e1we"),
	"closed_eyes_open_mouth" : load("uid://com1b61n30y2n"),
	"open_eyes_closed_mouth" : load("uid://dkq186kkjdit7"),
	"open_eyes_open_mouth" : load("uid://bxpqglhpf6cg3"),
	"red_eyes_closed_mouth": load("uid://m7tjf0wgkm37"),
	"red_eyes_open_mouth" : load("uid://dlohobvhaowq0"),
	"anomaly" : load("uid://css6fhexa8mm2")}
	
var is_blinking: bool = false
var is_anomaly: bool = false

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
	AnomalyServer.anomalies_reset.connect(_on_anomalies_reset)
			
func apply_anomaly():
	is_anomaly = true
	_update_main_texture()
	anomaly_timer.start(randf_range(8.0, 12.0))
	add_to_group("reportable_anomaly")

func revert_anomaly():
	is_anomaly = false
	anomaly_timer.stop()
	_update_main_texture()
	remove_from_group("reportable_anomaly")
		
func _update_main_texture():
	if is_anomaly:
		if anomaly == AnomalyServer.ANOMALY.GIRL:
			texture = textures["anomaly"]
		elif anomaly == AnomalyServer.ANOMALY.EYES:
			if is_talking:
				texture = textures["red_eyes_open_mouth"]
			else:
				texture = textures["red_eyes_closed_mouth"]
		else:
			push_error("Unknown anomaly in girl's script")
		return
	
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
	if is_talking: return
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
	
	
func _on_anomalies_reset():
	var arr = AnomalyServer.current_anomalies
	if arr[AnomalyServer.ANOMALY.EYES]:
		anomaly = AnomalyServer.ANOMALY.EYES
		apply_anomaly()
	elif arr[AnomalyServer.ANOMALY.GIRL]:
		anomaly = AnomalyServer.ANOMALY.GIRL
		apply_anomaly()
	
func _on_anomaly_timer_timeout():
	if is_anomaly:
		girl_scream.emit()
