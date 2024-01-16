class_name RangedComponent extends Node2D

@onready var shoot_position: Marker2D = $ShootPosition

func shoot(direction: Vector2, projectile: PackedScene, velocity_offset: Vector2) -> void:
	var projectile_instance: Projectile = projectile.instantiate()
	projectile_instance.direction = direction
	projectile_instance.player_speed = velocity_offset
	projectile_instance.position = shoot_position.global_position
	add_child(projectile_instance)
