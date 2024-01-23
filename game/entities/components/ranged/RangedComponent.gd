class_name RangedComponent extends Node2D

@export var use_cooldown: bool = false
@export var cooldown: float = 0.5:
	set(value): timer.wait_time = value
	get: return timer.wait_time

@onready var timer: Timer = $ShootCooldown
@onready var shoot_position: Marker2D = $ShootPosition
var is_enabled: bool = true

func shoot(direction: Vector2, projectile: PackedScene, velocity_offset: Vector2) -> bool:
	if is_enabled:
		var projectile_node: Node2D = projectile.instantiate()
		var projectile_instance: Projectile = projectile_node.get_node("Projectile")
		projectile_instance.position = shoot_position.global_position
		projectile_instance.direction = direction
		projectile_instance.velocity_offset = velocity_offset
		add_child(projectile_node)
		if use_cooldown:
			disable()
			timer.start()
		return true
	return false

func disable():
	is_enabled = false
	timer.stop()

func enable():
	is_enabled = true

func disable_timer():
	use_cooldown = false

func enable_timer():
	use_cooldown = true
