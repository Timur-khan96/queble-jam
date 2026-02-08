extends Node

@onready var coins_label := %coins_label
@onready var fader = %fader
@onready var girl = $girl
@onready var music_stream = $music_stream


var room_manager: RoomManager
var report_manager: ReportManager

var coins_tween: Tween
var animated_coins: int = 0:
	set(value):
		animated_coins = value
		coins_label.text = "$: %d" % animated_coins

func _ready():
	GameData.restart_needs()
	_start_day()
	room_manager = RoomManager.new(girl, %h_needs_container, %v_needs_container)
	add_child(room_manager)
	room_manager.day_finished.connect(_on_day_finished)
	room_manager.girl_screamer_request.connect(_scream)
	
	report_manager = ReportManager.new(fader, %report_button)
	add_child(report_manager)
	
	girl.girl_scream.connect(_scream)
	
	GameData.coins_updated.connect(_on_coins_updated)
	GameData.coins = 100
	_on_coins_updated()
	GameData.refill_fridge()
	
	
func _start_day(fader_time: int = 1):
	girl.is_dirty = true
	AnomalyServer.reset_anomalies()
	if GameData.day == 1:
		music_stream.play()
	else:
		GameData.restart_needs()
		if GameData.day == 2:
			await _stop_music()
	await fader.fade_from_black(fader_time)
	_morning_phrase()
	
func _morning_phrase():
	girl.say(Consts.morning_phrases.pick_random())
	
func _input(event):
	if Input.is_action_just_pressed_by_event("exit", event):
		get_tree().quit()
	if Input.is_action_just_pressed_by_event("enter", event):
		if OS.has_feature("web"):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#if Input.is_action_just_pressed_by_event("skip", event):
		#for n in GameData.needs:
			#if n == Consts.NEED_TYPE.ENERGY:
				#GameData.needs[n] = 0
			#else:
				#GameData.needs[n] = 1
		#GameData.needs_updated.emit()
		
func _on_coins_updated():
	if coins_tween:
		coins_tween.kill()
		coins_tween = null
	coins_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	coins_tween.tween_property(self, "animated_coins", GameData.coins, 1)
	
func _on_day_finished():
	girl.say(Consts.evening_phrases.pick_random())
	await girl.finished_talking
	await fader.fade_to_black()
	if AnomalyServer.are_active_anomalies():
		GameData.day = 1
	else:
		GameData.day += 1
	_start_day()
	
func _scream():
	var screamer = $screamer
	if screamer.visible: return
	
	girl.hide()
	$ui_layer.hide()
	music_stream.stream = load("uid://bw3gpq8cn8kui")
	music_stream.play()
	screamer.show()
	for i in range(3):
		await get_tree().create_timer(0.5).timeout
		screamer.material.set_shader_parameter("invert", true)
		await get_tree().create_timer(0.2).timeout
		screamer.material.set_shader_parameter("invert", false)
		await get_tree().create_timer(0.5).timeout
	GameData.day = 1
	get_tree().reload_current_scene()
	
func _stop_music():
	var idx := AudioServer.get_bus_index("Music")
	var curr := db_to_linear(AudioServer.get_bus_volume_db(idx))
	var start := curr
	while(curr > 0):
		curr -= 0.1
		AudioServer.set_bus_volume_db(idx, linear_to_db(curr))
		await get_tree().create_timer(0.2).timeout
	music_stream.stop()
	AudioServer.set_bus_volume_db(idx, linear_to_db(start))
