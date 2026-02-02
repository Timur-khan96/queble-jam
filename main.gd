extends Node2D

@onready var coins_label = %coins_label
@onready var boredom_button = %boredom_button
@onready var hunger_button = %hunger_button

var current_room_node

func _ready():
	for type in GameData.FOOD_TYPE:
		GameData.fridge_items[GameData.FOOD_TYPE[type]] = randi_range(0,3)
		
func _process(delta):
	coins_label.text = "💰: %d" % GameData.coins
	GameData.hunger += delta
	GameData.boredom += delta
	boredom_button.text = "Boredom: %d" % int(GameData.boredom)
	hunger_button.text = "Hunger: %d" % int(GameData.hunger)
	

			
			
