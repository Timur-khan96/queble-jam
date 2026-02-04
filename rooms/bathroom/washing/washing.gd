extends Control

signal closed

@onready var soap = %soap
@onready var shower_head = %shower_head
@onready var mask_viewport = %mask_viewport
@onready var mask_brush = %mask_brush
@onready var dirt = %dirt

enum STATE {IDLE, SOAP, SHOWER}

var _mouse_node: Sprite2D = null
var state: STATE = STATE.IDLE:
	set(value):
		if state == value: return
		state = value
		if _mouse_node != null:
			_mouse_node.queue_free()
			_mouse_node = null
		if state == STATE.IDLE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			_init_mouse_follow()
			
func _ready():
	var dirt_texture := load("uid://d1w1ynfge08dp")
	mask_viewport.size = dirt_texture.get_size()
	
func _init_mouse_follow():
	_mouse_node = Sprite2D.new()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	match state:
		STATE.SOAP:
			_mouse_node.texture = soap.texture
			shower_head.visible = true
			soap.visible = false
			_mouse_node.scale = Vector2(0.4, 0.4)
		STATE.SHOWER:
			_mouse_node.texture = shower_head.texture
			soap.visible = true
			shower_head.visible = false
			_mouse_node.scale = Vector2(0.5, 0.4)
	_mouse_node.z_index = 100
	add_child(_mouse_node)
	_mouse_node.global_position = get_global_mouse_position()
			
func _physics_process(delta):
	if _mouse_node == null: return
	_mouse_node.global_position = lerp(_mouse_node.global_position,
		get_global_mouse_position(), 8.5 * delta)
		
	if state == STATE.SOAP:
		var mouse_global = get_global_mouse_position()
		var local = dirt.to_local(mouse_global)

		var tex_size = dirt.texture.get_size()
		var uv = (local + tex_size * 0.5) / tex_size

		mask_brush.position = uv * Vector2(mask_viewport.size)
		mask_brush.visible = true
	else:
		mask_brush.visible = false
			
func _on_return_button_pressed():
	state = STATE.IDLE
	closed.emit()

func _on_shower_head_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			state = STATE.SHOWER

func _on_soap_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			state = STATE.SOAP
