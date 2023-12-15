class_name DamageAbleEntity extends CharacterBody2D

enum Element { Water, Fire, Neutral }

var entity_health: int = 100
var entity_element: Element = Element.Neutral

func _init(health: int, element: Element):
	entity_health = health
	entity_element = element

func takeDamage(amount: int, damage_type: Element):
	if damage_type == entity_element:
		return
	entity_health -= amount
	if entity_health <= 0:
		die()

func restoreHealth(amount: int):
	entity_health += amount

func die():
	queue_free()
