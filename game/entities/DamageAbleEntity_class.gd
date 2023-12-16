class_name DamageAbleEntity extends CharacterBody2D

enum Element { Water, Fire, Neutral }

var max_health: int = 100
var health: int = 100
var entity_element: Element = Element.Neutral

signal entity_death
signal change_health(new_health)

func _init(_entity_element: Element, _max_health: int):
	max_health = _max_health
	health = max_health
	entity_element = _entity_element

func take_damage(amount: int, damage_type: Element):
	if damage_type != Element.Neutral and damage_type == entity_element:
		return
	health -= amount
	if health <= 0:
		die()
	change_health.emit(health)

func restore_health(health_amount: int):
	health = maxi(health + health_amount, max_health)
	change_health.emit(health)

func die():
	entity_death.emit()
	queue_free()
