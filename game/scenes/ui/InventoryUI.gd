extends Panel

@onready var inventory_text: RichTextLabel = $Inventory
@onready var use_item_text: RichTextLabel = $"Use _E_"
@onready var active_item_meter: ProgressBar = $ProgressBar
@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready():
	player.inventory.on_item_in_inventory_updated.connect(update_item_in_inventory)
	player.inventory.on_item_used.connect(update_item_in_use)

func update_item_in_use(item: Item, amount: int):
	active_item_meter.visible = amount > 0
	active_item_meter.value = (amount / item.max_amount) * 100

func update_item_in_inventory(new_item: Item, old_item: Item):
	if new_item:
		inventory_text.text = new_item.name
		use_item_text.text = "Use 'E'"
	else:
		inventory_text.text = "none"
		use_item_text.text = ""
		
