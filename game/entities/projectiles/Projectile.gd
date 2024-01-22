class_name Projectile extends RigidBody2D

@export var element: Element.Type = Element.Type.Water
@export var speed: int = 1500
@export var damage: int = 20
@export var sprite: Texture2D
@export var collision_shape: CollisionShape2D
@export var new_collision_mask: int = 5
@export var sticky: bool = false

const LIFE_TIME_SECONDS: int = 4
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var player_speed: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

func _ready():
	get_node("Area2D").collision_mask = new_collision_mask
	if collision_shape: $Area2D/CollisionShape2D.set_shape(collision_shape)
	if sprite: $Sprite2D.texture = sprite
	set_linear_velocity((direction * speed) + player_speed)
	await get_tree().create_timer(LIFE_TIME_SECONDS).timeout
	queue_free()

func _on_area_2d_body_entered(body):
	var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
	if !sticky:
		if health_component:
			health_component.take_damage(damage, element)
		if body is Player and element != Element.Type.Water:
			body.heat_component.increase_heat(damage)
		get_parent().queue_free()
	else:
		if health_component:
			health_component.take_damage_overtime(damage, element, 30)
		linear_velocity = Vector2(0, 0)
		gravity_scale = 0
		var curr_pos = global_position
		top_level = false
		reparent.call_deferred(body)
		await get_tree().process_frame
		global_position = curr_pos
