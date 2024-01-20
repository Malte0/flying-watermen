class_name ChemicalStateManager extends Node

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var state_chart: StateChart = %StateChart

func _input(event: InputEvent):
	if event.is_action_pressed("activate_item"):
		if player.inventory.active_item:
			var active_chemical: String = player.inventory.active_item.name
			state_chart.set_expression_property("active_chemical", active_chemical)
			state_chart.send_event("to_chemical")
	if event.is_action_pressed("exit_state"):
		state_chart.send_event("to_default")
		player.inventory.set_active_item(null)
