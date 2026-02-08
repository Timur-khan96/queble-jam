extends Room

signal computer_opened()
signal computer_closed()

@export var computer_scene: PackedScene
var computer_node: Node

@onready var audio = $AudioStreamPlayer
@onready var head = $head

var computer_on_stream: AudioStream = load("uid://oertmbi6ab0p")
var computer_off_stream: AudioStream = load("uid://dff75vkkeq820")

func _ready():
	super._ready()
			
func _start_computer():
	if computer_node != null: 
		push_error("Trying to start existing computer")
		return
	audio.stream = computer_on_stream
	audio.play()
	computer_node = computer_scene.instantiate()
	computer_node.closed.connect(_close_computer)
	add_child(computer_node)
	if head.is_in_group("reportable_anomaly"):
		head.hide_anomaly()
	computer_opened.emit()
	
func _close_computer():
	if computer_node == null:
		push_error("Trying to close null computer")
		return
	if computer_node.minigame_node:
		GameData.update_coins(computer_node.minigame_node.score)
	audio.stream = computer_off_stream
	audio.play()
	computer_node.queue_free()
	computer_node = null
	head.sync_anomaly()
	computer_closed.emit()

func _input(event):
	if computer_node == null: return
	if Input.is_action_just_pressed_by_event("exit", event):
		_close_computer()
		get_viewport().set_input_as_handled()

func _on_background_pressed():
	var anomalies = AnomalyServer.current_anomalies
	if anomalies[AnomalyServer.ANOMALY.GIRL] or anomalies[AnomalyServer.ANOMALY.EYES] or anomalies[AnomalyServer.ANOMALY.SPEECH]:
		girl_screamer_request.emit()
	else:
		_start_computer()
