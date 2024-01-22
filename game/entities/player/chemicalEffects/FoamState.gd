extends Node2D

@export var player: Player
@export var chemical_state_chart: StateChart

var can_automatic_fire: bool = false
var has_automatic_cooldown: float = 0.0

var can_foam_attack: bool = false
var is_meele_shot_count: int = 10

func _on_foam_state_entered():
	can_automatic_fire = true
	player.projectile_scene = load("res://entities/projectiles/FoamProjectile.tscn")

func _on_foam_state_processing(delta):
	var projectile_node = player.projectile_scene.instantiate()
	var projectile_instance = projectile_node.get_node("Projectile")
	if can_automatic_fire and Input.is_action_pressed("right_click"):
		has_automatic_cooldown += delta
		if has_automatic_cooldown > 0.07:
			has_automatic_cooldown -= 0.07
			projectile_instance.position = player.shoot_position.global_position
			projectile_instance.direction = global_position.direction_to(get_global_mouse_position())
			projectile_instance.player_speed = player.velocity
			add_child(projectile_node)
			player.inventory.use_active_item(1)
	if player.inventory.active_item_left == 0:
		chemical_state_chart.send_event("to_default")

func _on_foam_state_exited():
	can_automatic_fire = false
	player.projectile_scene = load("res://entities/projectiles/WaterProjectile.tscn")
	chemical_state_chart.send_event("to_default")
