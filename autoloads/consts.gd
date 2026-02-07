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
	FOOD_TYPE.CHICKEN : 40,
	FOOD_TYPE.FISH : 50,
	FOOD_TYPE.APPLE: 5,
	FOOD_TYPE.TOMATO: 10,
	FOOD_TYPE.CHEESE: 30
}

const FOOD_SATIATION: Dictionary[FOOD_TYPE, float] = {
	FOOD_TYPE.CHICKEN : 0.4,
	FOOD_TYPE.FISH : 0.5,
	FOOD_TYPE.APPLE: 0.05,
	FOOD_TYPE.TOMATO: 0.1,
	FOOD_TYPE.CHEESE: 0.3
}

const FUN_INCREASE_RATE = 0.04

const morning_phrases: Array[String] = [
	"What a beautiful day! If only I weren't that hungry, bored and filthy.",
	"I had such an amazing dream!",
	"Wake up and smile, so much is ahead!"
]

const evening_phrases: Array[String] = [
	"All good things come to an end.",
	"I had a wonderful day!",
	"I hope tomorrow will be just as good!"
]
