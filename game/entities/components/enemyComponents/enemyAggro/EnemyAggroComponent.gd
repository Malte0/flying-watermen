class_name AggroComponent extends Node2D

@onready var state_chart: StateChart = $StateChart
@onready var aggro_cooldown_timer: Timer = $AggroCooldown

@export var view_area: Area2D
@export var health_component: HealthComponent

var is_aggro: bool = false

signal aggro_entered()
signal calm_entered()

func _ready():
	view_area.body_entered.connect(on_body_detected)
	view_area.body_exited.connect(on_body_exited)
	health_component.health_changed.connect(on_health_changed)

func on_body_detected(body):
	if body is Player and aggro_cooldown_timer.is_inside_tree():
		aggro_cooldown_timer.stop()
		state_chart.send_event("enter_aggro")

func on_body_exited(body):
	if body is Player and aggro_cooldown_timer.is_inside_tree():
		aggro_cooldown_timer.start()

func on_health_changed(_new_health, delta_health):
	if delta_health < 0:
		state_chart.send_event("enter_aggro")

func _on_aggro_state_entered():
	print("enter aggro")
	is_aggro = true
	aggro_entered.emit()

func _on_calm_state_entered():
	print("exit aggro")
	is_aggro = false
	calm_entered.emit()

func _on_aggro_cooldown_timeout():
	state_chart.send_event("enter_calm")
