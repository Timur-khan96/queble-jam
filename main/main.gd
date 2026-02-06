extends Node

@onready var coins_label := %coins_label
@onready var fader = %fader
@onready var girl = $girl

var room_manager: RoomManager
var report_manager: ReportManager

func _ready():
	room_manager = RoomManager.new(girl, %h_needs_container, %v_needs_container)
	add_child(room_manager)
	room_manager.day_finished.connect(_on_day_finished)
	
	report_manager = ReportManager.new(fader, %report_button)
	add_child(report_manager)
	
	GameData.coins_updated.connect(_on_coins_updated)
	_on_coins_updated()
	
	girl.is_dirty = true
	await fader.fade_from_black()
	_morning_phrase()
	
func _morning_phrase():
	girl.say(Consts.morning_phrases.pick_random())
	
func _input(event):
	if Input.is_action_just_pressed_by_event("exit", event):
		get_tree().quit()
	if Input.is_action_just_pressed_by_event("skip", event):
		for n in GameData.needs:
			if n == Consts.NEED_TYPE.ENERGY:
				GameData.needs[n] = 0
			else:
				GameData.needs[n] = 1
		GameData.needs_updated.emit()
	if Input.is_action_just_pressed_by_event("test", event):
		girl.scale *= 2
		
func _on_coins_updated():
	coins_label.text = "💰: %d" % GameData.coins
	
func _on_day_finished():
	girl.say(Consts.evening_phrases.pick_random())
	await girl.finished_talking
	await fader.fade_to_black()
	if AnomalyServer.are_active_anomalies():
		GameData.day = 1
	else:
		GameData.day += 1
	girl.is_dirty = true
	AnomalyServer.reset_anomalies()
	await fader.fade_from_black()
	_morning_phrase()
