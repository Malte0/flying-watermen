extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var state_chart: StateChart = %StateChart

var has_automatic_cooldown: float = 0.0

func _on_foam_state_entered():
	player.projectile_scene = load("res://entities/projectiles/FoamProjectile.tscn")
	player.ranged_component.disable_timer()

func _on_foam_state_processing(delta):
	if Input.is_action_pressed("right_click"):
		has_automatic_cooldown += delta
		if has_automatic_cooldown > 0.07:
			has_automatic_cooldown -= 0.07
			player.shoot()
			player.inventory.use_active_item(1)
	if player.inventory.active_item_left == 0:
		state_chart.send_event("to_default")

func _on_foam_state_exited():
	player.projectile_scene = load("res://entities/projectiles/WaterProjectile.tscn")
	player.ranged_component.enable_timer()
