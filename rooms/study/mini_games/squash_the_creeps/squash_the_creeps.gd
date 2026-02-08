extends Node

signal game_over()
signal restart_pressed()

var mob_scene: PackedScene

@onready var spawn_location = $Path3D/SpawnLocation
@onready var player = $player
@onready var score_label = %score_label
@onready var high_score_label = %high_score_label
@onready var pop_stream = $pop_stream
@onready var combo_label = %combo_label
@onready var combo_label_show_timer = %combo_label_show_timer
@onready var combo_animation = $combo_control/combo_animation


var combo_tween: Tween

var collision_anomaly := false
var score: int = 0
var combo: int = 0

const combo_texts = ["", "", "DOUBLE", "TRIPLE", "MEGA", "RAMPAGE", "GODLIKE", "WHUUT",
"GET OUTTA HERE", "ONE MORE AND IT'S ARRAY OUT OF BOUNDS"]

func _ready():
	mob_scene = load("uid://c253seh5dhukh")
	_update_score(0)
	_update_high_score(GameData.creeps_high_score)
	_update_combo(0)
	%game_over_control.hide()
	
func _physics_process(_delta):
	if player == null: return
	if combo > 0 and player.on_floor:
		_update_combo(0)

func _update_score(new_value):
	score = new_value
	score_label.text = "Score: %d" % score
	if score > GameData.creeps_high_score:
		_update_high_score(score)
	
func _update_high_score(new_value):
	GameData.creeps_high_score = new_value
	high_score_label.text = "High score: %d" % new_value
	
func _update_combo(new_value: int):
	if combo == new_value: return
	combo = new_value
	if new_value > 0:
		combo_label.text = combo_texts[combo]
		combo_label_show_timer.start()
		combo_animation.play("rotate")


func _on_mob_timer_timeout():
	var mob: CharacterBody3D = mob_scene.instantiate()
	spawn_location.progress_ratio = randf()
	
	if collision_anomaly:
		mob.collision_mask = 2
	else:
		mob.collision_mask = 0

	var player_position = player.position
	mob.initialize(spawn_location.position, player_position)
	mob.squashed.connect(_on_mob_squashed)
	add_child(mob)
	
func _input(_event):
	if Input.is_action_just_pressed("test"):
		collision_anomaly = !collision_anomaly

func _on_player_hit():
	pop_stream.play()
	$MobTimer.stop()
	$score_timer.stop()
	%game_over_control.show()
	GameData.update_coins(score)
	score = 0
	game_over.emit()
	
func _on_mob_squashed():
	var new_value := 2 * (combo + 1)
	print("mob reward: %d" % new_value)
	_update_score(score + new_value)
	pop_stream.play()
	_update_combo(combo + 1)

func _on_score_timer_timeout():
	_update_score(score + 1)

func _on_restart_button_pressed():
	restart_pressed.emit()

func _on_combo_label_show_timer_timeout():
	combo_label.text = ""
