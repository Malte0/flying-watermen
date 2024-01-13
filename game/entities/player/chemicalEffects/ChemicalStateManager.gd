class_name ChemicalStateManager extends Node

@export var player: Player
@export var player_sprite_container: Node2D

func _input(event: InputEvent):
	if event.is_action_pressed("activate_item"):
		if player.inventory.active_item:
			var active_chemical: String = player.inventory.active_item.name
			player.state_chart.set_expression_property("active_chemical", active_chemical)
			player.state_chart.send_event("to_chemical")
	if event.is_action_pressed("exit_state"):
		player.state_chart.send_event("to_default")
		player.inventory.set_active_item(null)

func update_player_graphics(effect_name: String):
	var sprites: Array = player_sprite_container.get_children()
	for sprite in sprites:
		sprite.visible = sprite.name == effect_name

func _on_ice_state_entered():
	update_player_graphics("ice")
	player.inventory.use_active_item(1)

func _on_ice_state_exited() -> void:
	update_player_graphics("default")
