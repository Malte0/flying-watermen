class_name Projectile extends CharacterBody2D

@export var SPEED: int = 1500
@export var DAMAGE: int = 20

var direction: Vector2 = Vector2.ZERO
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var impact_detector: Area2D = $ImpactDetector

func _ready():
	velocity = direction * SPEED

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta 
	move_and_slide()

func _on_impact_detector_body_entered(body):
	if body is Enemy:
		body.health_component.take_damage(DAMAGE, Element.Type.Water)
	queue_free()

func _on_life_timer_timeout():
	queue_free()
