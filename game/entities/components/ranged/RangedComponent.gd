class_name RangedComponent extends Node2D

@onready var state_chart: StateChart = %StateChart
@onready var can_shoot: State = %CanShoot
@onready var shoot_position: Marker2D = $ShootPosition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot(direction: Vector2, projectile: PackedScene, velocity_offset: Vector2) -> void:
	state_chart.send_event("_on_shot")
	var projectile_instance: Projectile = projectile.instantiate()
	projectile_instance.position = shoot_position.global_position
	projectile_instance.direction = direction
	projectile_instance.player_speed = velocity_offset
	add_child(projectile_instance)
