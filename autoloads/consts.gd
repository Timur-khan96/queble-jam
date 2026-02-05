extends Node

enum ROOM_TYPE {STUDY, KITCHEN, BATHROOM, BEDROOM, }
enum FOOD_TYPE {CHICKEN, FISH, APPLE, TOMATO, CHEESE}
enum NEED_TYPE {FUN, HUNGER, HYGIENE, ENERGY }

const ROOM_SCENES: Dictionary[ROOM_TYPE, String] = {
	ROOM_TYPE.KITCHEN: "uid://diwfruugpm3da",
	ROOM_TYPE.BEDROOM: "uid://cm6t3f5aj8qot",
	ROOM_TYPE.BATHROOM: "uid://chk5yvsnluif0",
	ROOM_TYPE.STUDY: "uid://dayq0jsuq8unw"
}

const NEED_ICONS: Dictionary[NEED_TYPE, String] = {
	NEED_TYPE.HUNGER : "uid://dqidq4st60k6y", 
	NEED_TYPE.FUN : "uid://by3x7mtpsfcrb",
	NEED_TYPE.ENERGY : "uid://ccni8k7dcxhju",
	NEED_TYPE.HYGIENE : "uid://buko02mfac1nv" 
}

const FOOD_PRICES: Dictionary[FOOD_TYPE, int] = {
	FOOD_TYPE.CHICKEN : 80,
	FOOD_TYPE.FISH : 100,
	FOOD_TYPE.APPLE: 10,
	FOOD_TYPE.TOMATO: 40,
	FOOD_TYPE.CHEESE: 60
}

const FOOD_SATIATION: Dictionary[FOOD_TYPE, float] = {
	FOOD_TYPE.CHICKEN : 0.36,
	FOOD_TYPE.FISH : 0.40,
	FOOD_TYPE.APPLE: 0.12,
	FOOD_TYPE.TOMATO: 0.2,
	FOOD_TYPE.CHEESE: 0.28
}

const FUN_INCREASE_RATE = 0.04
