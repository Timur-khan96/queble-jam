extends Control

signal closed

enum STATE {IDLE, SOAP, SHOWER}

@onready var soap = %soap
@onready var shower_head = %shower_head
@onready var mask_viewport = %mask_viewport
@onready var mask_brush = %mask_brush
@onready var dirt = %dirt
@onready var naked_girl = $naked_girl
@onready var return_button = %return_button


var _mouse_node: Node2D = null
var shower_scene = load("uid://btnp1u3uj17pm")
var foam_scene = load("uid://cxjtxschawytu")

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
			
			
const BRUSH_RADIUS = 128
const GRID_X := 48
var GRID_Y: int

var dirt_grid := PackedByteArray()   # size = GRID_X * GRID_Y
var clean_grid := PackedByteArray()  # size = GRID_X * GRID_Y
var brush_radius_uv: Vector2

var total_dirt_cells := 0
var total_cleaned_cells: = 0
var cleaned_percent: float = 0.
var foam_counter := 0

var dirt_tex_size: Vector2
			
func _ready():
	var dirt_texture := load("uid://d1w1ynfge08dp")
	dirt_tex_size = dirt_texture.get_size()
	mask_viewport.size = dirt_tex_size
	var aspect = dirt_tex_size.y / dirt_tex_size.x
	GRID_Y = int(GRID_X * aspect)
	_build_dirt_grid(dirt_texture)
	brush_radius_uv = Vector2(BRUSH_RADIUS / dirt_tex_size.x, 
		BRUSH_RADIUS / dirt_tex_size.y)
	_position_girl()
	return_button.hide()
		
func _position_girl():
	var rect_size = get_viewport_rect().size
	var x_offset_factor = 0.5
	naked_girl.position.x = rect_size.x * x_offset_factor
	var y_offset = naked_girl.texture.get_height() * naked_girl.scale.y / 2
	naked_girl.position.y = rect_size.y - y_offset
	
func _build_dirt_grid(texture: Texture2D):
	dirt_grid.resize(GRID_X * GRID_Y)
	clean_grid.resize(GRID_X * GRID_Y)
	dirt_grid.fill(0)
	clean_grid.fill(0)
	total_dirt_cells = 0

	var img: Image = texture.get_image()
	var cell_width = img.get_width() / float(GRID_X)
	var cell_height = img.get_height() / float(GRID_Y)

	for gy in GRID_Y:
		for gx in GRID_X:
			var x0 = int(gx * cell_width)
			var y0 = int(gy * cell_height)
			var x1 = int((gx + 1) * cell_width)
			var y1 = int((gy + 1) * cell_height)

			var has_dirt := false
			for y in range(y0, y1):
				for x in range(x0, x1):
					if img.get_pixel(x, y).a > 0.05:
						has_dirt = true
						break
				if has_dirt: break
			
			if has_dirt:
				dirt_grid[gy * GRID_X + gx] = 1
				total_dirt_cells += 1
	
	
func _init_mouse_follow():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	match state:
		STATE.SOAP:
			_mouse_node = Sprite2D.new()
			_mouse_node.texture = soap.texture
			shower_head.visible = true
			soap.visible = false
			_mouse_node.scale = Vector2(0.4, 0.4)
		STATE.SHOWER:
			_mouse_node = shower_scene.instantiate()
			soap.visible = true
			shower_head.visible = false
	_mouse_node.z_index = 100
	add_child(_mouse_node)
	_mouse_node.global_position = get_global_mouse_position()
			
func _physics_process(delta):
	if _mouse_node == null: return
	_mouse_node.global_position = lerp(_mouse_node.global_position,
		get_global_mouse_position(), 12.5 * delta)
		
	if state == STATE.SOAP:
		if cleaned_percent >= 0.9:
			mask_brush.visible = false
			return
		var mouse_global = get_global_mouse_position()
		var local = dirt.to_local(mouse_global)
		var uv = (local + dirt_tex_size * 0.5) / dirt_tex_size

		mask_brush.position = uv * Vector2(mask_viewport.size)
		mask_brush.visible = true
		apply_cleaning_uv(uv)
	else:
		mask_brush.visible = false
		
func apply_cleaning_uv(uv: Vector2):
	var center_gx = int(uv.x * GRID_X)
	var center_gy = int(uv.y * GRID_Y)

	var rx = int(ceil(brush_radius_uv.x * GRID_X))
	var ry = int(ceil(brush_radius_uv.y * GRID_Y))

	for gy in range(center_gy - ry, center_gy + ry + 1):
		if gy < 0 or gy >= GRID_Y: continue
		for gx in range(center_gx - rx, center_gx + rx + 1):
			if gx < 0 or gx >= GRID_X: continue
			
			var cell_uv = Vector2((gx + 0.5) / GRID_X, (gy + 0.5) / GRID_Y)
			var dx = (cell_uv.x - uv.x) / brush_radius_uv.x
			var dy = (cell_uv.y - uv.y) / brush_radius_uv.y
			if dx * dx + dy * dy > 1.0: continue
			
			var idx = gy * GRID_X + gx
			if dirt_grid[idx] == 1 and clean_grid[idx] == 0:
				clean_grid[idx] = 1
				total_cleaned_cells += 1
				_update_clean_percent()
				if randi() % 4 == 0:
					_spawn_foam(gx, gy)
				
func _update_clean_percent():
	var result: float = total_cleaned_cells / float(total_dirt_cells)
	if result >= 0.9:
		cleaned_percent = 1.0
		dirt.hide()
	else:
		cleaned_percent = result
		
func _spawn_foam(gx: int, gy: int):
	var foam: Area2D = foam_scene.instantiate()
	foam.position = Vector2(
		(gx + 0.5) / GRID_X * dirt_tex_size.x - dirt_tex_size.x * 0.5,
		(gy + 0.5) / GRID_Y * dirt_tex_size.y - dirt_tex_size.y * 0.5
	)
	foam.rotation = randf_range(0, TAU)
	foam.scale *= randf_range(0.8, 1.2)
	foam.z_index = dirt.z_index + 1
	foam_counter += 1
	foam.tree_exited.connect(_on_foam_exited)
	naked_girl.add_child(foam)
			
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
			
func _on_foam_exited():
	foam_counter -= 1
	if foam_counter == 0:
		GameData.update_need(Consts.NEED_TYPE.HYGIENE, 1)
		return_button.show()
