class_name HealthComponent extends Node2D

@export var element: Element.Type = Element.Type.Neutral
@export var max_health: int = 100
## Optional for heal_over_time
@export var _heal_tick: Timer
## Optional to display health. Automatically assigned for Player
@export var _health_bar: TextureProgressBar
## Damage shader effect if target got damage
@export var use_damage_effect: bool = false

@onready var iframe_duration: Timer = $IFrames

const HEAL_OVER_TIME_STEP: int = 5
const HEALTH_BAR_SPEED: float = 2
const SPEED_THRESHOLD: float = 25

var heal_over_time_left: int = 0
var health: int = 100
var is_invincible: bool = false
var has_iframes: bool = false

var can_take_damage_over_time: int = 0

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

func take_damage(amount: int, damage_type: Element.Type, trigger_iframes: bool = true):
	if not can_take_damage(damage_type): return
	if amount <= 0: return
	if trigger_iframes:
		if has_iframes: return
		enable_iframes(0.1)
		if use_damage_effect: damage_flash_effect()
	health -= amount
	health_changed.emit(health, -amount)

func can_take_damage(damage_type: Element.Type) -> bool:
	if is_invincible: return false
	else: return damage_type == Element.Type.Neutral or not damage_type == element

# there is no need to use to check for iframes, cuz the func deals no primary dmg
func take_damage_overtime(amount: int, damage_type: Element.Type, time: int):
	if can_take_damage_over_time <= 5:
		can_take_damage_over_time += 1
		while time >= 0:
			take_damage(amount, damage_type, false)
			time -= 1
			await get_tree().create_timer(0.3).timeout
		can_take_damage_over_time -= 1

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

func damage_flash_effect():
	var sprite: AnimatedSprite2D = %AnimatedSprite2D
	sprite.modulate = Color.INDIAN_RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1,1,1)

func enable_iframes(time: float):
	has_iframes = true
	iframe_duration.wait_time = time
	iframe_duration.start()

func disable_iframes():
	has_iframes = false

func _on_health_changed(new_health: int, _delta_health: int) -> void:
	if new_health <= 0: die()
