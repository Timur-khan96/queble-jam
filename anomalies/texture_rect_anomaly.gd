extends TextureRect

@export var anomaly: AnomalyServer.ANOMALY

func _ready():
	if AnomalyServer.current_anomalies[anomaly]:
		show_anomaly()

func show_anomaly():
	visible = true
	add_to_group("reportable_anomaly")

func hide_anomaly():
	visible = false
	remove_from_group("reportable_anomaly")
