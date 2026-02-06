extends Node
class_name ReportManager

var fader: ColorRect

func _init(_fader: ColorRect, report_button: BaseButton):
	report_button.pressed.connect(_on_report_button_pressed)
	fader = _fader
	
func _on_report_button_pressed():
	var nodes := get_tree().get_nodes_in_group("reportable_anomaly")
	if nodes.is_empty():
		return

	await fader.fade_to_black()

	for n in nodes:
		if n.has_method("revert_anomaly"):
			n.revert_anomaly()
		elif n.has_method("hide_anomaly"):
			n.hide_anomaly()
		AnomalyServer.current_anomalies[n.anomaly] = false

	fader.fade_from_black()
	
