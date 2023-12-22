class_name HealthComponent extends Node2D

@export var element: Element.Type = Element.Type.Neutral
@export var max_health: int = 100
@export var health_bar: TextureProgressBar
const HEALTH_BAR_INTERPOLATION_SPEED: int = 1
var current_health: int = 100

signal health_change(new_health, delta_health)
signal death

func _ready():
	current_health = max_health

func _process(_delta):
	if health_bar == null:
		return
	if current_health != health_bar.value:
		health_bar.value = move_toward(health_bar.value, current_health, HEALTH_BAR_INTERPOLATION_SPEED)

func take_damage(amount: int, damage_type: Element.Type):
	if damage_type != Element.Type.Neutral and damage_type == element:
		return
	current_health -= amount
	if current_health <= 0:
		die()
	health_change.emit(current_health, -amount)

func restore_health(amount: int):
	current_health = maxi(current_health + amount, max_health)
	health_change.emit(current_health, amount)

func die():
	death.emit()
	get_parent().queue_free()
