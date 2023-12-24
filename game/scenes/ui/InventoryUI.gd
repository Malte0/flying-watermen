extends PanelContainer

@onready var inventory_text: RichTextLabel = $Inventory

@onready var player: Player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	if player.inventory.item_in_inventory:
		inventory_text.text = player.inventory.item_in_inventory.name
