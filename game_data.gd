extends Node

enum ROOM_TYPE {KITCHEN, BEDROOM, BATHROOM, STUDY}
enum FOOD_TYPE {CHICKEN, FISH, APPLE, TOMATO, CHEESE}

const ROOM_SCENES: Dictionary[ROOM_TYPE, String] = {
	ROOM_TYPE.KITCHEN: "uid://diwfruugpm3da",
	ROOM_TYPE.BEDROOM: "uid://cm6t3f5aj8qot",
	ROOM_TYPE.BATHROOM: "uid://chk5yvsnluif0",
	ROOM_TYPE.STUDY: "uid://dayq0jsuq8unw"
}

const FOOD_PRICES: Dictionary[FOOD_TYPE, int] = {
	FOOD_TYPE.CHICKEN : 80,
	FOOD_TYPE.FISH : 100,
	FOOD_TYPE.APPLE: 10,
	FOOD_TYPE.TOMATO: 40,
	FOOD_TYPE.CHEESE: 60
} #satiation is the same

var fridge_items: Dictionary[FOOD_TYPE, int]
var coins: int = 100

var hunger: float = 0
var boredom: float = 0
