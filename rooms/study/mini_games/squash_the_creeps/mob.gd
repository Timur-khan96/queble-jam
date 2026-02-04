extends CharacterBody3D

signal squashed

@export var min_speed = 8
@export var max_speed = 15

func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(randf_range(-PI / 6, PI / 6))
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func _physics_process(_delta):
	move_and_slide()

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()
	
func squash():
	squashed.emit()
	queue_free()
