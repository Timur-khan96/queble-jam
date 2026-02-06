extends Area2D

const anomaly := AnomalyServer.ANOMALY.SHOWER

func _ready():
	if AnomalyServer.current_anomalies[AnomalyServer.ANOMALY.SHOWER]:
		apply_anomaly()

func apply_anomaly():
	%particles.process_material.color = Color.RED
	add_to_group("reportable_anomaly")

func revert_anomaly():
	%particles.process_material.color = Color.WHITE
	remove_from_group("reportable_anomaly")
