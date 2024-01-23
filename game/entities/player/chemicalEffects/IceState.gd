extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var state_chart: StateChart = %StateChart
@onready var heat_component: HeatComponent:
	get: return player.heat_component

const ICE_FRICTION: float = 0.02

func _ready() -> void:
	player.ready.connect(_on_player_ready)

func _on_player_ready():
	heat_component.heat_changed.connect(_on_heat_component_heat_changed)

# Replace this by depleting the inventory item bar
func _on_heat_component_heat_changed(new_heat: int, _delta_heat: int) -> void:
	if new_heat >= heat_component.MAX_HEAT: state_chart.send_event("melt")

func _on_ice_state_entered():
	heat_component.heat = 0
	player.animate_state("ice")
	player.friction = ICE_FRICTION
	player.health_component.is_invincible = true
	player.disenable_components(false, false, false)
	
	player.inventory.set_active_item(null)
	player.direction = 0

func _on_ice_state_exited() -> void:
	heat_component.heat = 0
	player.animate_state("water")
	player.friction = player.base_friction
	player.health_component.is_invincible = false
	player.disenable_components(true, true, true)
