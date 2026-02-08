extends Node
class_name ReportManager

var fader: ColorRect
var correct_report_stream: AudioStreamPlayer

func _init(_fader: ColorRect, report_button: BaseButton):
	report_button.pressed.connect(_on_report_button_pressed)
	fader = _fader
	correct_report_stream = AudioStreamPlayer.new()
	correct_report_stream.stream = load("uid://ck4o2vu0aqqcl")
	correct_report_stream.bus = &"FX"
	add_child(correct_report_stream)
	
func _on_report_button_pressed():
	var nodes := get_tree().get_nodes_in_group("reportable_anomaly")
	if nodes.is_empty(): return
	correct_report_stream.play()
	await fader.fade_to_black()

	for n in nodes:
		if n.has_method("revert_anomaly"):
			n.revert_anomaly()
		elif n.has_method("hide_anomaly"):
			n.hide_anomaly()
		print(AnomalyServer.ANOMALY.keys()[n.anomaly])
		AnomalyServer.current_anomalies[n.anomaly] = false

	fader.fade_from_black()
	
