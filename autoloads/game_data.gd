extends Node

signal needs_updated()
signal coins_updated()
signal day_updated() #only calendar is catching

var needs: Dictionary[Consts.NEED_TYPE, float]
var fridge_items: Dictionary[Consts.FOOD_TYPE, int]
var coins: int = 0

var day: int = 1:
	set(value):
		if day == value: return
		day = value
		day_updated.emit()

var creeps_high_score: int = 0

func refill_fridge():
	for type in Consts.FOOD_TYPE:
		fridge_items[Consts.FOOD_TYPE[type]] = randi_range(0,3)

func restart_needs():
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
		
		if need == Consts.NEED_TYPE.HUNGER or need == Consts.NEED_TYPE.FUN:
			needs[Consts.NEED_TYPE.ENERGY] = max(0, energy - (value * 0.3))
	else:
		needs[need] = max(0, new_value)
	needs_updated.emit()
	
func update_coins(value: int):
	coins = max(0, coins + value)
	coins_updated.emit()
