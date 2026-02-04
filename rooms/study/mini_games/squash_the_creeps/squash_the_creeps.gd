extends Node

signal game_over()

var mob_scene: PackedScene

@onready var spawn_location = $Path3D/SpawnLocation
@onready var player = $player

@onready var score_label = %score_label
@onready var high_score_label = %high_score_label

var collision_anomaly := false
var score: int = 0

func _ready():
	mob_scene = load("uid://c253seh5dhukh")
	_update_score(0)
	_update_high_score(GameData.creeps_high_score)
	%game_over_label.hide()

func _update_score(new_value):
	score = new_value
	score_label.text = "Score: %d" % score
	if score > GameData.creeps_high_score:
		_update_high_score(score)
	
func _update_high_score(new_value):
	GameData.creeps_high_score = new_value
	high_score_label.text = "High score: %d" % new_value

func _on_mob_timer_timeout():
	var mob: CharacterBody3D = mob_scene.instantiate()
	spawn_location.progress_ratio = randf()
	
	if collision_anomaly:
		mob.collision_mask = 2
	else:
		mob.collision_mask = 0

	var player_position = player.position
	mob.initialize(spawn_location.position, player_position)
	mob.squashed.connect(func(): 
		_update_score(score + 1))
	add_child(mob)
	
func _input(_event):
	if Input.is_action_just_pressed("test"):
		collision_anomaly = !collision_anomaly

func _on_player_hit():
	$MobTimer.stop()
	%game_over_label.show()
	GameData.update_coins(score)
	game_over.emit()
