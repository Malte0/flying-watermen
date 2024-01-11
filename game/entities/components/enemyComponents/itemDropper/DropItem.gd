extends Node2D

@export var carried_item: Item
@export var health_component: HealthComponent

func _ready():
	health_component.death.connect(drop_item)

func drop_item():
	if carried_item:
		call_deferred("spawn_item")

func spawn_item():
	var item_instance: Collectable = carried_item.collectable.instantiate()
	item_instance.position = position
	get_parent().add_child(item_instance)
