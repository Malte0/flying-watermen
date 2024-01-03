extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var state_chart: StateChart = $AttackStateChart
@onready var tmp_animation_bar: ProgressBar = $ProgressBar

const MELEE_DAMAGE: int = 50
const TWEEN_DURATION: float = 0.1

func _on_body_entered(body):
	if body is Enemy:
		body.health_component.take_damage(MELEE_DAMAGE, Element.Type.Water)

func _input(event: InputEvent):
	if event.is_action_pressed("attack"):
		state_chart.send_event("attack")

func _on_attack_state_entered():
	tmp_animation_bar.visible = true
	tmp_animation_bar.value = 0
	var tween = get_tree().create_tween()
	tween.tween_property(tmp_animation_bar, "value", 100, TWEEN_DURATION)
	collision_shape.disabled = false

func _on_attack_state_exited():
	tmp_animation_bar.visible = false
	collision_shape.disabled = true
