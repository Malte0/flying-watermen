extends Node2D

@export var player: Player
@export var heat_component: HeatComponent

@onready var state_chart: StateChart = %StateChart
@onready var ice_state: State = %Ice

const ICE_FRICTION: float = 0.02

func _ready():
	heat_component.heat_changed.connect(_on_heat_changed)
	ice_state.state_entered.connect(_on_ice_state_entered)
	ice_state.state_exited.connect(_on_ice_state_exited)

# Replace this by depleting the inventory item bar
func _on_heat_changed(new_heat: int, _delta_heat: int):
	if new_heat >= heat_component.MAX_HEAT:
		state_chart.send_event("melt")

func _on_ice_state_entered():
	heat_component.heat = 0
	player.direction = 0
	player.friction = ICE_FRICTION
	player.health_component.is_invincible = true
	state_chart.send_event("disable_movement")
	player.inventory.set_active_item(null)

func _on_ice_state_exited() -> void:
	heat_component.heat = 0
	player.friction = player.base_friction
	player.health_component.is_invincible = false
	state_chart.send_event("to_default")
	state_chart.send_event("enable_movement")
