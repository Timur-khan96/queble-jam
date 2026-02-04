extends Control

signal closed

enum STATE {IDLE, SOAP, SHOWER}

@onready var soap = %soap
@onready var shower_head = %shower_head
@onready var mask_viewport = %mask_viewport
@onready var mask_brush = %mask_brush
@onready var dirt = %dirt
@onready var naked_girl = $naked_girl


@onready var test_label = %test_label

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
			
			
const BRUSH_RADIUS = 128
const GRID_X := 48
var GRID_Y: int

var dirt_grid := PackedByteArray()   # size = GRID_X * GRID_Y
var clean_grid := PackedByteArray()  # size = GRID_X * GRID_Y
var brush_radius_uv: Vector2
var total_dirt_cells := 0
			
func _ready():
	var dirt_texture := load("uid://d1w1ynfge08dp")
	var tex_size = dirt_texture.get_size()
	mask_viewport.size = tex_size
	var aspect = tex_size.y / tex_size.x
	GRID_Y = int(GRID_X * aspect)
	_build_dirt_grid(dirt_texture)
	brush_radius_uv = Vector2(BRUSH_RADIUS / tex_size.x, 
		BRUSH_RADIUS / tex_size.y)
	
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
	
func _process(_delta):
	test_label.text = "cleaned: %d%%" % [get_clean_percent() * 100]
			
func _physics_process(delta):
	if _mouse_node == null: return
	_mouse_node.global_position = lerp(_mouse_node.global_position,
		get_global_mouse_position(), 12.5 * delta)
		
	if state == STATE.SOAP:
		var mouse_global = get_global_mouse_position()
		var local = dirt.to_local(mouse_global)

		var tex_size = dirt.texture.get_size()
		var uv = (local + tex_size * 0.5) / tex_size

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
			# Cell center in UV
			var cell_uv = Vector2((gx + 0.5) / GRID_X, (gy + 0.5) / GRID_Y)
			# Elliptical distance check
			var dx = (cell_uv.x - uv.x) / brush_radius_uv.x
			var dy = (cell_uv.y - uv.y) / brush_radius_uv.y
			if dx * dx + dy * dy > 1.0: continue
			
			var idx = gy * GRID_X + gx
			if dirt_grid[idx] == 1 and clean_grid[idx] == 0:
				clean_grid[idx] = 1
				
func get_clean_percent() -> float:
	var cleaned := 0
	for i in dirt_grid.size():
		if dirt_grid[i] == 1 and clean_grid[i] == 1:
			cleaned += 1
	return float(cleaned) / total_dirt_cells
			
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
