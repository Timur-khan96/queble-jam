extends Control

@onready var fridge_list: ItemList = %fridge_list
@onready var give_button := %give_button
@onready var buy_button := %buy_button


var fridge_items: Dictionary[Consts.FOOD_TYPE, int] = GameData.fridge_items

func _ready():
	_update_fridge()
	GameData.coins_updated.connect(_update_buttons)
	
func _update_fridge():
	var selected_arr = fridge_list.get_selected_items()
	fridge_list.clear()
	for item in fridge_items:
		fridge_list.add_item("%s: %d" % [Consts.FOOD_TYPE.keys()[item], 
			fridge_items[item]])
	if !selected_arr.is_empty():
		fridge_list.select(selected_arr[0])
	_update_buttons()
	
func _update_buttons():
	var selected_arr = fridge_list.get_selected_items()
	if selected_arr.is_empty():
		give_button.disabled = true
		buy_button.disabled = true
		buy_button.text = "Buy"
	else:
		var index = selected_arr[0]
		give_button.disabled = !fridge_items[index] > 0
		var price = Consts.FOOD_PRICES[index]
		buy_button.disabled = GameData.coins < price
		buy_button.text = "Buy (%d)" % price

func _on_give_button_pressed():
	var selected_arr = fridge_list.get_selected_items()
	if selected_arr.is_empty():
		push_error("Trying to give but nothing is selected in the fridge!")
		return
		
	var selected_idx = selected_arr[0]
	if fridge_items[selected_idx] <= 0:
		push_error("No food item like this to give!!!")
		return
	
	fridge_items[selected_idx] -= 1
	GameData.update_need(Consts.NEED_TYPE.HUNGER, Consts.FOOD_SATIATION[selected_idx])
	_update_fridge()
	
func _on_fridge_list_item_selected(_index):
	_update_buttons()
	
func _on_buy_button_pressed():
	var selected_arr = fridge_list.get_selected_items()
	if selected_arr.is_empty():
		push_error("Trying to buy but nothing is selected in the fridge!")
		return
	var selected_idx = selected_arr[0]
	fridge_items[selected_idx] += 1
	GameData.update_coins(-Consts.FOOD_PRICES[selected_idx])
	_update_fridge()
		
	
