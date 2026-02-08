extends TextureRect

@export var anomaly: AnomalyServer.ANOMALY

func _ready():
	visible = false
	AnomalyServer.anomalies_reset.connect(sync_anomaly)
	#AnomalyServer.anomaly_resolved.connect(_on_resolved)
	sync_anomaly()
		
func sync_anomaly():
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
