extends Node

@onready var coins_label := %coins_label
@onready var fader = %fader
@onready var girl = $girl


var room_manager: RoomManager

func _ready():
	room_manager = RoomManager.new(girl, %h_needs_container, %v_needs_container)
	add_child(room_manager)
	GameData.coins_updated.connect(_on_coins_updated)
	_on_coins_updated()
	fader.fade_out_finished.connect(_morning_phrase)
	girl.is_dirty = true
	await fader.show_day()
	fader.fade_out()
	
func _morning_phrase():
	girl.say("What a beautiful day! If only I weren't that hungry, bored and filthy.")
	
func _input(event):
	if Input.is_action_just_pressed_by_event("exit", event):
		get_tree().quit()
		
func _on_coins_updated():
	coins_label.text = "💰: %d" % GameData.coins
