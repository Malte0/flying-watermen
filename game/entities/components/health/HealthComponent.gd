class_name HealthComponent extends Node2D

@export var element: Element.Type = Element.Type.Neutral
@export var max_health: int = 100
## Optional for heal_over_time
@export var _heal_tick: Timer
## Optional to display health. Automatically assigned for Player
@export var _health_bar: TextureProgressBar

const HEAL_OVER_TIME_STEP: int = 5
const HEALTH_BAR_SPEED: float = 2
const SPEED_THRESHOLD: float = 25

var heal_over_time_left: int = 0
var health: int = 100
var is_invincible: bool = false

signal health_changed(new_health: int, delta_health: int)
signal death()

func _ready():
	health = max_health
	if get_parent() is Player:
		_health_bar = get_tree().get_first_node_in_group("playerHealthHeatBar")
		if not _health_bar: print_debug("Player Healthbar not found")
	if _health_bar:
		_health_bar.max_value = max_health
		_health_bar.value = health
	if _heal_tick: _heal_tick.timeout.connect(_on_heal_tick)

func _process(_delta):
	if _health_bar and health != _health_bar.value:
		var multiplier: float = max(abs((_health_bar.value - health) / SPEED_THRESHOLD), 1)
		_health_bar.value = move_toward(_health_bar.value, health, HEALTH_BAR_SPEED * multiplier)

func take_damage(amount: int, damage_type: Element.Type):
	if is_invincible:
		return
	if damage_type != Element.Type.Neutral and damage_type == element:
		return
	health -= amount
	health_changed.emit(health, -amount)
	if health <= 0:
		die()

func heal(amount: int):
	health = mini(health + amount, max_health)
	health_changed.emit(health, amount)

func heal_over_time(amount: int):
	heal_over_time_left += amount

func _on_heal_tick():
	if heal_over_time_left > 0:
		var amount_to_heal: int = mini(heal_over_time_left, HEAL_OVER_TIME_STEP)
		heal(amount_to_heal)
		heal_over_time_left = maxi(heal_over_time_left - HEAL_OVER_TIME_STEP, 0)

func die():
	death.emit()
	get_parent().queue_free()
