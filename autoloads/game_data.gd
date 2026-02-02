extends Node

var needs: Dictionary[Consts.NEED_TYPE, float]
var fridge_items: Dictionary[Consts.FOOD_TYPE, int]
var coins: int = 100

var hunger: float = 0
var boredom: float = 0

func _ready():
	for type in Consts.FOOD_TYPE:
		fridge_items[Consts.FOOD_TYPE[type]] = randi_range(0,3)
	for need in Consts.NEED_TYPE:
		needs[Consts.NEED_TYPE[need]] = 0.5
