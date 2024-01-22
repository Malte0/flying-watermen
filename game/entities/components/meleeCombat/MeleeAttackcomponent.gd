class_name MeleeAttackComponent extends Area2D

@export var damage: int = 50
@export var element: Element.Type
@export var attack_shape: CollisionShape2D
@export var attack_color: Color

@onready var state_chart: StateChart = $AttackStateChart
@onready var tmp_animation_bar: ProgressBar = $ProgressBar

const ATTACK_DURATION: float = 0.1
## To makes sure no body is hit twice
var bodies_hit: Array[CharacterBody2D] = []

func _ready():
	if attack_shape.shape is RectangleShape2D:
		var _size: Vector2 = attack_shape.shape.size
		var _position: Vector2 = attack_shape.position
		tmp_animation_bar.position.x = _position.x - _size.x / 2
		tmp_animation_bar.position.y = _position.y - _size.y / 2
		tmp_animation_bar.size = _size
	else:
		push_warning("Attack shape is expected to be a RectangleShape2D")
	attack_shape.disabled = true
	tmp_animation_bar.visible = false
	tmp_animation_bar.modulate = attack_color

func _on_body_entered(body):
	var health_component: HealthComponent = body.get_node_or_null("HealthComponent")
	if health_component and body not in bodies_hit:
		health_component.take_damage(damage, element)
		bodies_hit.append(body)
		await get_tree().create_timer(ATTACK_DURATION).timeout
		if weakref(body).get_ref() and body in bodies_hit:
			bodies_hit.erase(body)

func attack():
	state_chart.send_event("attack")

func _on_attack_state_entered():
	tmp_animation_bar.visible = true
	tmp_animation_bar.value = 0
	var tween = get_tree().create_tween()
	tween.tween_property(tmp_animation_bar, "value", 100, ATTACK_DURATION)
	attack_shape.disabled = false

func _on_attack_state_exited():
	tmp_animation_bar.visible = false
	attack_shape.disabled = true
