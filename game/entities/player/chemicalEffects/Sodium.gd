extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var state_chart: StateChart = %StateChart

const SODIUM_DAMAGE: int = 5

func _on_sodium_state_entered() -> void:
	player.projectile_scene = load("res://entities/projectiles/sodium/SodiumProjectile.tscn")

func _on_sodium_state_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if player.shoot():
			player.health_component.take_damage(SODIUM_DAMAGE, Element.Type.Neutral)
			player.inventory.use_active_item(1)
		if player.inventory.active_item_left == 0:
			state_chart.send_event("to_default")

func _on_sodium_state_exited() -> void:
	player.projectile_scene = load("res://entities/projectiles/WaterProjectile.tscn")
