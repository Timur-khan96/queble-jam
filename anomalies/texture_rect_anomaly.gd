extends TextureRect

@export var anomaly: AnomalyServer.ANOMALY

func _ready():
	visible = false
	AnomalyServer.anomalies_reset.connect(_sync)
	#AnomalyServer.anomaly_resolved.connect(_on_resolved)
	_sync()
		
func _sync():
	if AnomalyServer.current_anomalies.get(anomaly, false):
		show_anomaly()
	else:
		hide_anomaly()

func show_anomaly():
	visible = true
	add_to_group("reportable_anomaly")

func hide_anomaly():
	visible = false
	remove_from_group("reportable_anomaly")
