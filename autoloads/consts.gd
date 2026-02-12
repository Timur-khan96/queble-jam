extends Node

enum ROOM_TYPE {STUDY, KITCHEN, BATHROOM, BEDROOM, }
enum FOOD_TYPE {APPLE, TOMATO, CHEESE, FISH, CHICKEN}
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
	FOOD_TYPE.APPLE: 5,
	FOOD_TYPE.TOMATO: 10,
	FOOD_TYPE.CHEESE: 15,
	FOOD_TYPE.FISH : 30,
	FOOD_TYPE.CHICKEN : 35
}

const FOOD_SATIATION: Dictionary[FOOD_TYPE, float] = {
	FOOD_TYPE.APPLE: 0.1,
	FOOD_TYPE.TOMATO: 0.2,
	FOOD_TYPE.CHEESE: 0.3,
	FOOD_TYPE.FISH : 0.4,
	FOOD_TYPE.CHICKEN : 0.5
}

const FUN_INCREASE_RATE = 0.04

const morning_phrases: Array[String] = [
	"Good day to you too, sunshine~",
	"I'm glad to see you again",
	"Oh, I had such a dream...",
	"I am so hungryyy!",
	"I saw you in my dream! We were fighting kaiju together, and you were so cool~",
	"I think I might start doing pottery",
	"I think lost my sock while I was asleep...",
	"Let's cancel all plans, order pizza and play It Takes Two all day?",
	"Why a person always wakes up hungry?",
	"I'm sorry, dear, have you seen my comb?"
]

const evening_phrases: Array[String] = [
	"What a productive day it was",
	"I hope you don't mind if I hook my leg over yours",
	"I have so little energy throughout the day... I think I might be depressed",
	"I wrote a  poem! Wanna hear? Tomato, fish, cheese. My life is fleeting away. Dreaming awake.",
	"See you soon, handsome~",
	"Please don't forget to take care of yourself — eat, sleep, and wash up, dear",
	"Your hands are so gentle~"
]

const cursed_phrases_html_friendly: Array[String] = [
	"I wish for you to find someone who will mourn you when you're gone",
	"It's not me who's stuck in the meaningless cycle",
	"I hope your friends won't forget about you when you're gone",
	"What's the point of being alive?",
	"I love you being so pathetic"
]
