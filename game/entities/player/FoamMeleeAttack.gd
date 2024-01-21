extends Area2D

@export var player: Player

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player_state_chart: StateChart = $StateChart
@onready var attack_state_chart: StateChart = $AttackStateChart
@onready var foam_state_chart: StateChart = $FoamAttackStateChart

@onready var projectile_scene: PackedScene = load("res://entities/projectiles/WaterProjectile.tscn")
@onready var shoot_position: Marker2D = $ShootPosition

var in_foam: bool = false

func _input(event: InputEvent):
	if event.is_action_pressed("attack"):
		foam_state_chart.send_event("foamattack")

func _on_attack_state_entered():
	if in_foam:
		for i in 10:
			player_state_chart.send_event("_on_shot")
			var projectile_node: Node2D = projectile_scene.instantiate()
			var projectile_instance: Projectile = projectile_node.get_node("Projectile")
			projectile_instance.position = shoot_position.global_position
			projectile_instance.direction = global_position.direction_to(Vector2(10/i,10/i))
			add_child(projectile_node)
			player.inventory.use_active_item(1)

func _on_attack_state_exited():
	collision_shape.disabled = false
