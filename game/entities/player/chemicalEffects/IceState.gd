extends Node2D

@export var player: Player
@export var heat_component: HeatComponent
@export var effects_state_chart: StateChart

@onready var ice_image: Sprite2D = $"../Sprites/iceImage"
@onready var default_image: Sprite2D = $"../Sprites/defaultImage"

const ICE_FRICTION: float = 0.01

func _ready():
	heat_component.heat_changed.connect(_on_heat_changed)

func display_default(is_default_state: bool):
	ice_image.visible = not is_default_state
	default_image.visible = is_default_state

func _input(event: InputEvent):
	if event.is_action_pressed("activate_ability"):
		effects_state_chart.send_event("to_ice")
		heat_component.heat = 0
		player.direction = 0
		player.friction = ICE_FRICTION
		player.health_component.is_immune = true
		display_default(false)

# replace this by depleting the inventory item bar
func _on_heat_changed(new_heat: int, _delta_heat: int):
	if new_heat >= heat_component.MAX_HEAT:
		effects_state_chart.send_event("to_default")
		player.health_component.is_immune = false
		display_default(true)
