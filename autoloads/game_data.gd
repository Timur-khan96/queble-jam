extends Node

signal needs_updated()
signal coins_updated()

var needs: Dictionary[Consts.NEED_TYPE, float]
var fridge_items: Dictionary[Consts.FOOD_TYPE, int]
var coins: int = 100

var creeps_high_score: int = 0

func _ready():
	for type in Consts.FOOD_TYPE:
		fridge_items[Consts.FOOD_TYPE[type]] = randi_range(0,3)
	for need in Consts.NEED_TYPE:
		needs[Consts.NEED_TYPE[need]] = 0.6
		
func decrease_needs():
	for need in needs:
		var value = Consts.NEED_DECREASE_RATE[need]
		needs[need] = max(0, needs[need] - value)
	needs_updated.emit()
	
func update_need(need: Consts.NEED_TYPE, value: float):
	needs[need] = min(1., value + needs[need])
	needs_updated.emit()
	
func update_coins(value: int):
	coins = max(0, coins + value)
	coins_updated.emit()
