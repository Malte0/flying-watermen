class_name SodiumProjectile extends RigidBody2D

var explosion_scene: PackedScene = preload("res://entities/projectiles/explosion/Explosion.tscn")
@onready var explosion_delay: Timer = $ExplosionDelay
@onready var impact_detector: Area2D = $ImpactDetector

const SPEED: int = 1400
const EXPLOSION_DELAY: float = 0.4

var direction: Vector2 = Vector2.ZERO
var additional_speed: Vector2 = Vector2.ZERO

func _ready():
	linear_velocity = direction * SPEED + additional_speed
	explosion_delay.timeout.connect(spawn_explosion)
	impact_detector.body_entered.connect(spawn_explosion)
	await get_tree().create_timer(EXPLOSION_DELAY).timeout
	spawn_explosion("")

func add_to_parent(explosion_instance: Explosion):
	get_parent().add_child(explosion_instance)

func spawn_explosion(_placeholder):
	var explosion_instance: Explosion = explosion_scene.instantiate()
	explosion_instance.global_position = global_position
	# This call deferred is needed to prevent a weird godot error being thrown
	call_deferred("add_to_parent", explosion_instance)
	call_deferred("queue_free")
