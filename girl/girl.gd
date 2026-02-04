extends Sprite2D

@onready var blink_timer = $blink_timer
@onready var censorship = $censorship
@onready var dirt = $dirt

var textures: Dictionary[String, Texture2D] = {
	"closed_eyes_closed_mouth" : load("uid://do3mnunq5e1we"),
	"closed_eyes_open_mouth" : load("uid://com1b61n30y2n"),
	"open_eyes_closed_mouth" : load("uid://dkq186kkjdit7"),
	"open_eyes_open_mouth" : load("uid://bxpqglhpf6cg3"),
	"naked_closed_mouth" : load("uid://b4f2rcchw673r"),
	"naked_open_mouth" : load("uid://djcdvvw8jjiqc")}
	
var is_talking: bool = false

var is_washing: bool = false:
	set(value):
		if is_washing == value: return
		is_washing = value
		censorship.visible = is_washing
		if is_washing:
			texture = textures["naked_open_mouth"] if is_talking else \
				textures["naked_closed_mouth"]
		else:
			texture = textures["open_eyes_open_mouth"] if is_talking else \
				textures["open_eyes_closed_mouth"]
			blink_timer.start()
			
var is_dirty: bool = false:
	set(value):
		if is_dirty == value: return
		is_dirty = value
		dirt.visible = is_dirty

func _on_blink_timer_timeout():
	if is_washing: return
	if is_talking:
		texture = textures["closed_eyes_open_mouth"]
	else:
		texture = textures["closed_eyes_closed_mouth"]
	await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
	if is_talking:
		texture = textures["open_eyes_open_mouth"]
	else:
		texture = textures["open_eyes_closed_mouth"]
	blink_timer.start(randf_range(3, 6))
	
