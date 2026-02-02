extends Control
@onready var item_list: ItemList = $VBoxContainer/ItemList

var fridge_items: Dictionary[Consts.FOOD_TYPE, int] = GameData.fridge_items

func _ready():
	_update_buttons()
	_update_fridge()
	
func _update_buttons():
	var selected_arr = item_list.get_selected_items()
	if selected_arr.is_empty():
		%give_button.disabled = true
		%buy_button.disabled = true
	else:
		var index = selected_arr[0]
		%give_button.disabled = !fridge_items[index] > 0
		%buy_button.disabled = !GameData.coins > 0
	
func _update_fridge():
	item_list.clear()
	for item in fridge_items:
		item_list.add_item("%s: %d" % [Consts.FOOD_TYPE.keys()[item], 
			fridge_items[item]])

func _on_give_button_pressed():
	var selected_arr = item_list.get_selected_items()
	if selected_arr.is_empty():
		push_error("Trying to give on empty selected fridge items arr!!!")
		return
		
	var selected_idx = selected_arr[0]
	if fridge_items[selected_idx] <= 0:
		push_error("No food item like this to give!!!")
		return
	
	fridge_items[selected_idx] -= 1
	GameData.hunger -= Consts.FOOD_PRICES[selected_idx]
	_update_fridge()

func _on_item_list_item_selected(_index):
	_update_buttons()
	
