class_name Inventory extends Node2D

var item_in_inventory: Item = null

func add_item(item: Item):
	item_in_inventory = item

func remove_item():
	item_in_inventory = null
