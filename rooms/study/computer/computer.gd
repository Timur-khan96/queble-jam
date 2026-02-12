extends Control

signal closed()

@onready var sub_viewport = %SubViewport
@onready var fun_timer = $fun_timer
@onready var music_player = $music_player


@export var minigame_scene: PackedScene
var minigame_node: Node

func _ready():
	_resize_computer()
	get_viewport().size_changed.connect(_resize_computer)
	_restart_minigame()

func _resize_computer():
	var vp = get_viewport_rect().size
	var vp_scale = min(vp.x / 1920.0, vp.y / 1080.0)

	vp_scale = clamp(vp_scale, 0.6, 1.0)
	var target_size = Vector2i(1280 * vp_scale, 720 * vp_scale)
	sub_viewport.size = target_size
	sub_viewport.size_2d_override = target_size
	sub_viewport.size_2d_override_stretch = true
	$computer_container.custom_minimum_size = target_size
	
func _restart_minigame():
	if minigame_node != null:
		minigame_node.queue_free()
		minigame_node = null
	minigame_node = minigame_scene.instantiate()
	minigame_node.game_over.connect(_on_minigame_over)
	minigame_node.restart_pressed.connect(_restart_minigame)
	fun_timer.start()
	if GameData.day > 1 and !music_player.playing:
		$music_player.play()
	sub_viewport.add_child(minigame_node)
	
func _on_close_button_pressed():
	closed.emit()
	
func _input(event):
	if Input.is_action_just_pressed_by_event("enter", event):
		_restart_minigame()
		get_viewport().set_input_as_handled()
		
func _on_minigame_over():
	fun_timer.stop()

func _on_fun_timer_timeout():
	GameData.update_need(Consts.NEED_TYPE.FUN, Consts.FUN_INCREASE_RATE)
