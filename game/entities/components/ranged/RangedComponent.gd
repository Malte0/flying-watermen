class_name RangedComponent extends Node2D

@onready var shoot_position: Marker2D = $ShootPosition

func shoot(direction: Vector2, projectile: PackedScene, velocity_offset: Vector2) -> void:
	var projectile_node: Node2D = projectile.instantiate()
	var projectile_instance: Projectile = projectile_node.get_node("Projectile")
	projectile_instance.position = shoot_position.global_position
	projectile_instance.direction = direction
	projectile_instance.player_speed = velocity_offset
	add_child(projectile_node)
