class_name SodiumProjectile extends RigidBody2D

@onready var collision_detector: CollisionShape2D = $CollisionShape2
@onready var explosion_collider: CollisionShape2D = $ExplosionArea/ExplosionShape
@onready var explosion_delay: Timer = $Explosion
@onready var sprite: Sprite2D = $Sprite2D

const ELEMENT: Element.Type = Element.Type.Water
const SPEED: int = 20000
const DAMAGE: int = 50
const LIFE_TIME_SECONDS: int = 10
const EXPLOSION_DURATION: float = 1

var direction: Vector2 = Vector2.ZERO
var additional_speed: Vector2 = Vector2.ZERO

func _ready():
	linear_velocity = (direction + additional_speed) * SPEED
	explosion_collider.disabled = true
	explosion_delay.timeout.connect(explode)
	body_entered.connect(explode)
	await get_tree().create_timer(LIFE_TIME_SECONDS).timeout
	queue_free()

func explode():
	explosion_collider.disabled = false
	explosion_animation()
	await get_tree().create_timer(EXPLOSION_DURATION).timeout
	queue_free()

func explosion_animation():
	print("Play explosion animation")
	sprite.modulate = Color("blue")

func _on_explosion_area_body_entered(body):
	if body is Enemy:
		body.health_component.take_damage(DAMAGE, ELEMENT)
