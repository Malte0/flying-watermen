extends Node2D

@export var player: Player
@export var heat_component: HeatComponent
@export var chemical_state_chart: StateChart

const ICE_FRICTION: float = 0.02
var is_in_ice_state: bool = false

func _ready():
	heat_component.heat_changed.connect(_on_heat_changed)

func enter_ice_state():
	is_in_ice_state = true
	heat_component.heat = 0
	player.direction = 0
	player.friction = ICE_FRICTION
	player.health_component.is_invincible = true

func exit_ice_state():
	heat_component.heat = 0
	player.health_component.is_invincible = false
	chemical_state_chart.send_event("to_default")

# Replace this by depleting the inventory item bar
func _on_heat_changed(new_heat: int, _delta_heat: int):
	if new_heat >= heat_component.MAX_HEAT and is_in_ice_state:
		exit_ice_state()

func _on_ice_state_entered():
	enter_ice_state()
