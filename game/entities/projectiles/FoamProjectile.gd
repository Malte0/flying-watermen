class_name FoamProjectile extends CharacterBody2D

@export var impact_detector: Area2D
@export var element: Element.Type = Element.Type.Water
@export var speed: int = 10
@export var damage: int = 2

const LIFE_TIME_SECONDS: int = 5
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO

func _ready():
	velocity = (direction * speed) / 2
	#await get_tree().create_timer(LIFE_TIME_SECONDS).timeout
	#queue_free()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _on_impact_detector_body_entered(body):
	var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
	if health_component:
		health_component.take_damage(damage, element)
	if body is Player and element != Element.Type.Water:
		body.heat_component.increase_heat(damage)
	gravity = 0
	velocity.x = 0
	velocity.y = 0
