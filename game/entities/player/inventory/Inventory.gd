class_name Inventory extends Node2D

var item_in_inventory: Item = null
var active_item: Item = null

signal on_item_in_inventory_updated(new_item: Item, old_item: Item)
signal on_item_used(item: Item, amount)

func set_item_in_inventory(item: Item):
	on_item_in_inventory_updated.emit(item, item_in_inventory)
	item_in_inventory = item

func set_active_item(item: Item):
	on_item_used.emit(item, item.amount)
	active_item = item

func _process(_delta):
	if Input.is_action_just_pressed("use_item") and item_in_inventory:
		print("use item")
		set_active_item(item_in_inventory)
		set_item_in_inventory(null)
