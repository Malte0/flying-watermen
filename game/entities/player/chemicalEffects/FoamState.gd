extends Node2D

@export var player: Player
@export var chemical_state_chart: StateChart

var is_in_foam_state: bool = false

func _ready():
	pass

func enter_foam_state():
	is_in_foam_state = true

func exit_foam_state():
	chemical_state_chart.send_event("to_default")

func _on_foam_state_entered():
	#var projectile_instance: FoamProjectile = projectile_scene.instantiate()
	print("helo")
	enter_foam_state()


func _on_foam_state_physics_processing(delta):
	pass
