extends Node

signal anomalies_updated()

enum ANOMALY {HAND, GIRL, SHOWER, MINIGAME}

var current_anomalies: Dictionary[ANOMALY, bool]

func _ready():
	_clear_anomalies()
	
func _clear_anomalies():
	for a in ANOMALY.keys():
		current_anomalies[ANOMALY[a]] = false

func reset_anomalies():
	_clear_anomalies()
	for i in range(GameData.day - 1):
		var r = ANOMALY.keys().pick_random()
		current_anomalies[ANOMALY[r]] = true
		print(r)
	anomalies_updated.emit()
	
func are_active_anomalies() -> bool:
	for a in current_anomalies:
		if current_anomalies[a]: return true
	return false
		
