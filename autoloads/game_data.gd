extends Node

signal needs_updated()
signal coins_updated()
signal day_updated()

var needs: Dictionary[Consts.NEED_TYPE, float]
var fridge_items: Dictionary[Consts.FOOD_TYPE, int]
var coins: int = 100

var day: int = 1:
	set(value):
		if day == value: return
		day = value
		day_updated.emit()
		_restart_needs()

var creeps_high_score: int = 0

func _ready():
	for type in Consts.FOOD_TYPE:
		fridge_items[Consts.FOOD_TYPE[type]] = randi_range(0,3)
	_restart_needs()
		
func _restart_needs():
	print("restarting needs")
	for need in Consts.NEED_TYPE:
		needs[Consts.NEED_TYPE[need]] = 0
	needs[Consts.NEED_TYPE.ENERGY] = 1.
	needs_updated.emit()
	
func finish_washing():
	needs[Consts.NEED_TYPE.HYGIENE] = 1.0
	update_need(Consts.NEED_TYPE.ENERGY, -0.2)
	
func update_need(need: Consts.NEED_TYPE, value: float):
	var new_value: float = needs[need] + value
	if value > 0:
		needs[need] = min(1., new_value)
		var energy = needs[Consts.NEED_TYPE.ENERGY]
		
		if need == Consts.NEED_TYPE.HUNGER:
			needs[Consts.NEED_TYPE.ENERGY] = max(0, energy - (value * 0.2))
		elif need == Consts.NEED_TYPE.FUN:
			needs[Consts.NEED_TYPE.ENERGY] = max(0, energy - value)
	else:
		needs[need] = max(0, new_value)
	needs_updated.emit()
	
func update_coins(value: int):
	coins = max(0, coins + value)
	coins_updated.emit()
