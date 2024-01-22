extends Node2D

@export var carried_item: PackedScene
@export var health_component: HealthComponent

func _ready():
	health_component.death.connect(drop_item)

func drop_item():
	if carried_item:
		call_deferred("spawn_item")

func spawn_item():
	var collectable_instance: Node2D = carried_item.instantiate()
	collectable_instance.global_position = global_position
	get_parent().add_child(collectable_instance)
