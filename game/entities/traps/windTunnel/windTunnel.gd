@tool
extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

@export var force: float = 0
@export var lifetime: float = 0
@export var collision_shape: CollisionShape2D:
	set(value):
		collision_shape = value
		fit_particle()

var force_vector: Vector2:
	get: return Vector2(force, 0).rotated(rotation)
var bodys_in_wind_tunnel: Array = []

func fit_particle():
	var partic: GPUParticles2D = $GPUParticles2D
	partic.lifetime = lifetime
	partic.process_material.emission_box_extents = Vector3(0, collision_shape.shape.size.y, 0)
	partic.set_visibility_rect(Rect2(Vector2(0,0), collision_shape.shape.size))
	partic.amount = collision_shape.position.x / 3
	global_position = collision_shape.global_position - Vector2(collision_shape.shape.get_rect().size.x/2, 0).rotated(rotation)
	collision_shape.position = Vector2(collision_shape.shape.get_rect().size.x/2,0)

func _physics_process(delta):
	if Engine.is_editor_hint(): return
	for body in bodys_in_wind_tunnel:
		if body is CharacterBody2D:
			_apply_wind_to_char_body(body, delta)
		elif body is RigidBody2D:
			body.apply_impulse(force_vector * delta)

func _apply_wind_to_char_body(body, delta):
	var wind_direction_vel: float = body.velocity.dot(Vector2.from_angle(rotation))
	var wind_force_on_body: float = lerp(wind_direction_vel, force, 0.05)
	var wind_direction_force: float = min(wind_force_on_body,force) #max(wind_direction_vel,min(wind_force_on_body,force))
	var orth_wind_direc_vel: float = body.velocity.dot(Vector2.from_angle(rotation + PI/2))
	var new_wind_direction_vel: Vector2 = Vector2(wind_direction_force, 0).rotated(rotation)
	var new_orth_wind_direction_vel: Vector2 = Vector2(orth_wind_direc_vel,0).rotated(rotation+PI/2)
	body.velocity = new_wind_direction_vel + new_orth_wind_direction_vel

func _on_body_entered(body):
	bodys_in_wind_tunnel.append(body)

func _on_body_exited(body):
	if bodys_in_wind_tunnel.has(body):
		bodys_in_wind_tunnel.erase(body)

func _ready():
	fit_particle()
