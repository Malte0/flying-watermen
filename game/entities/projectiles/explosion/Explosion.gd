class_name Explosion extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

const DAMAGE: int = 50
const ELEMENT: Element.Type = Element.Type.Water
const DECAY_TIME: float = 0.4

func _ready():
	animation_player.play("SodiumExplosion")
	await get_tree().create_timer(DECAY_TIME).timeout
	queue_free()

func _on_body_entered(body):
	if body is Enemy:
		body.health_component.take_damage(DAMAGE, ELEMENT)
