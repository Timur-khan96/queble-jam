extends Node

signal anomalies_reset() #the girl

enum ANOMALY {
	EYES = 0,
	GIRL = 1,
	SHOWER = 2,
	COMPUTER = 3,
	PAINTING = 4,
	KNIFE = 5,
	TOASTER = 6,
	SPEECH = 7
}

var current_anomalies: Dictionary[ANOMALY, bool] = {}
var prev_day_anomalies: Dictionary[ANOMALY, bool] = {}
	
func _clear_anomalies():
	for a in ANOMALY.keys():
		current_anomalies[ANOMALY[a]] = false

func reset_anomalies():
	print("resetting anomalies")
	_clear_anomalies()
	var count = 4
	if GameData.day < count:
		count = GameData.day - 1
	var keys := ANOMALY.keys()
	while(count > 0):
		var k = keys.pick_random()
		if current_anomalies[ANOMALY[k]]: continue
		if prev_day_anomalies.has(ANOMALY[k]): continue
		if ANOMALY[k] == ANOMALY.GIRL and current_anomalies[ANOMALY.EYES]:
			continue #they can't be both true
		
		current_anomalies[ANOMALY[k]] = true
		count -= 1
	
	prev_day_anomalies.clear()
	for a in current_anomalies:
		if current_anomalies[a]:
			prev_day_anomalies[a] = true
	
	anomalies_reset.emit()
	
func are_active_anomalies() -> bool:
	for a in current_anomalies:
		if current_anomalies[a]: return true
	return false
		
