extends Room

signal washing_started
signal washing_closed

var washing_scene: PackedScene
var washing_node: Control

@onready var audio = $AudioStreamPlayer
@onready var toaster = $toaster


var curtains_stream_1 = load("uid://c5wfp4t1an64i")
var curtains_stream_2 = load("uid://cnbuggt0isjoa")


func _ready():
	super._ready()
	washing_scene = load("uid://ccxy8yvi4bx7y")
			
func _start_washing():
	if washing_node != null:
		push_error("Trying to start washing with existing washing node")
		return
	washing_node = washing_scene.instantiate()
	add_child(washing_node)
	washing_node.closed.connect(_close_washing)
	audio.stream = curtains_stream_1
	audio.play()
	if toaster.is_in_group("reportable_anomaly"):
		toaster.hide_anomaly()
	washing_started.emit()
	
	
func _close_washing():
	if washing_node == null:
		push_error("Trying to finish null washing")
		return
	washing_node.queue_free()
	washing_node = null
	audio.stream = curtains_stream_2
	audio.play()
	toaster.sync_anomaly()
	washing_closed.emit()
			

func _on_background_pressed():
	if is_equal_approx(GameData.needs[Consts.NEED_TYPE.HYGIENE], 1.):
		girl_say_request.emit("I'm already clean!")
		return
	var anomalies = AnomalyServer.current_anomalies
	if anomalies[AnomalyServer.ANOMALY.GIRL] or anomalies[AnomalyServer.ANOMALY.EYES] or anomalies[AnomalyServer.ANOMALY.SPEECH]:
		girl_screamer_request.emit()
	else:
		_start_washing()
