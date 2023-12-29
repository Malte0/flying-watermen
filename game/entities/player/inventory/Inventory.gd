class_name Inventory extends Node2D

var item_in_inventory: Item = null
var active_item: Item = null
var active_item_left: int = 0

signal on_item_in_inventory_updated(new_item: Item, old_item: Item)
signal on_item_activated(item: Item)
signal on_item_used(amount: int, max_amount: int)

func set_item_in_inventory(item: Item):
	on_item_in_inventory_updated.emit(item, item_in_inventory)
	item_in_inventory = item

func set_active_item(item: Item):
	on_item_activated.emit(item)
	active_item = item
	active_item_left = item.max_amount

func use_active_item(amount: int):
	if active_item:
		active_item_left = maxi(active_item_left - amount, 0) 
		on_item_used.emit(active_item_left, active_item.max_amount)

func _process(_delta):
	if Input.is_action_just_pressed("use_item") and item_in_inventory:
		set_active_item(item_in_inventory)
		set_item_in_inventory(null)
