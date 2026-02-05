extends Node

@onready var coins_label := %coins_label
@onready var fader = %fader
@onready var girl = $girl

var room_manager: RoomManager

func _ready():
	room_manager = RoomManager.new(girl, %h_needs_container, %v_needs_container)
	add_child(room_manager)
	room_manager.day_finished.connect(_on_day_finished)
	GameData.coins_updated.connect(_on_coins_updated)
	_on_coins_updated()
	fader.fade_out_finished.connect(_morning_phrase)
	girl.is_dirty = true
	#await fader.show_day()
	fader.fade_out()
	
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
		
func _on_coins_updated():
	coins_label.text = "💰: %d" % GameData.coins
	
func _on_day_finished():
	girl.say(Consts.evening_phrases.pick_random())
	await girl.finished_talking
	await fader.fade_in()
	if AnomalyServer.are_active_anomalies():
		GameData.day = 1
	else:
		GameData.day += 1
	AnomalyServer.reset_anomalies()
	fader.fade_out()


func _on_report_button_pressed():
	pass # Replace with function body.
