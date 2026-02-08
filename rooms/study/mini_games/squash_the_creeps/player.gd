extends CharacterBody3D

signal hit

@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
@onready var jump_stream = $jump_stream

const speed = 14
const fall_acceleration = 75
const jump_impulse = 20
const bounce_impulse = 16

var target_velocity = Vector3.ZERO
var on_floor: bool = true

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.basis = Basis.looking_at(direction)
		animation_player.speed_scale = 4
	else:
		animation_player.speed_scale = 1
		
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if is_on_floor():
		on_floor = true
		target_velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			target_velocity.y += jump_impulse
			on_floor = false
			jump_stream.play()
			
	else:
		target_velocity.y -= fall_acceleration * delta
	
	_check_collisions()
	
	velocity = target_velocity
	move_and_slide()
	pivot.rotation.x = PI / 6 * velocity.y / jump_impulse
	
func _check_collisions():
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		if collision.get_collider() == null: continue
		
		var collider = collision.get_collider()
		if collider.is_in_group("mob"):
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				on_floor = false
				collider.squash()
				target_velocity.y = bounce_impulse
				break

func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(_body):
	die()
