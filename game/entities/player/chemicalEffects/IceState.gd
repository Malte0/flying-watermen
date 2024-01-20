extends Node2D

@onready var chemical_state_chart: StateChart = %ChemicalStateChart
@onready var player: Player = get_tree().get_first_node_in_group("player")
var heat_component: HeatComponent: 
	get: return player.heat_component

const ICE_FRICTION: float = 0.02

# Replace this by depleting the inventory item bar
func _on_heat_component_heat_changed(new_heat: int, _delta_heat: int) -> void:
	if new_heat >= heat_component.MAX_HEAT:
		chemical_state_chart.send_event("melt")

func _on_ice_state_entered():
	heat_component.heat = 0
	player.animate_state("ice")
	player.friction = ICE_FRICTION
	player.health_component.is_invincible = true
	player.disable_shooting()
	player.disable_movement()
	player.disable_melee()
	
	player.inventory.set_active_item(null)
	player.direction = 0

func _on_ice_state_exited() -> void:
	heat_component.heat = 0
	player.animate_state("water")
	player.friction = player.base_friction
	player.health_component.is_invincible = false
	player.enable_shooting()
	player.enable_movement()
	player.enable_melee()
