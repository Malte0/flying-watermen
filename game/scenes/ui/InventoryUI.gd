extends Panel

@onready var inventory_text: RichTextLabel = $Inventory
@onready var active_item_text: RichTextLabel = $ActiveItem
@onready var use_item_text: RichTextLabel = $"Use _E_"
@onready var active_item_meter: ProgressBar = $ItemBar
@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready():
	player.inventory.on_item_in_inventory_updated.connect(update_item_in_inventory)
	player.inventory.on_item_activated.connect(update_active_item)
	player.inventory.on_item_used.connect(update_item_bar)
	update_item_bar(0, 0)
	update_item_in_inventory(null, null)

func update_item_in_inventory(new_item: Item, _old_item: Item):
	if new_item:
		inventory_text.text = new_item.name
		use_item_text.text = "Use 'E'"
	else:
		inventory_text.text = "no item in inventory"
		use_item_text.text = ""

func update_active_item(item: Item):
	active_item_text.visible = item != null
	if item:
		active_item_text.text = item.name
		update_item_bar(item.max_amount, item.max_amount)

func update_item_bar(amount: int, max_amount: int):
	active_item_meter.visible = amount > 0
	active_item_text.visible = amount > 0
	print(max_amount)
	active_item_meter.value = (amount / float(max_amount)) * 100
