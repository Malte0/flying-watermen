extends Node2D

@export var player: Player
@export var chemical_state_chart: StateChart

var automatic_fire: bool = false
var automatic_cooldown: float = 0.0

var can_foam_attack: bool = false
var meele_shot_count: int = 10

@onready var projectile_node: Node2D 
@onready var projectile_instance: Projectile

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_foam_attack:
		can_foam_attack = false
		for i in range(meele_shot_count):
			var vec: Vector2 = Vector2(100.0, -i*10)
			projectile_instance.position = player.shoot_position.global_position
			vec.x += projectile_instance.position.x
			vec.y += projectile_instance.position.y + 30
			projectile_instance.direction = global_position.direction_to(vec)
			#projectile_instance.player_speed = player.velocity
			add_child(projectile_node)
			player.inventory.use_active_item(1)
			await get_tree().create_timer(0.05).timeout
		can_foam_attack = true

func _on_foam_state_entered():
	automatic_fire = true
	player.projectile_scene = load("res://entities/projectiles/FoamProjectile.tscn")

func _on_foam_state_processing(delta):
	projectile_node = player.projectile_scene.instantiate()
	projectile_instance = projectile_node.get_node("Projectile")
	if automatic_fire and Input.is_action_pressed("right_click"):
		automatic_cooldown += delta
		if automatic_cooldown > 0.07:
			automatic_cooldown -= 0.07
			projectile_instance.position = player.shoot_position.global_position
			projectile_instance.direction = global_position.direction_to(get_global_mouse_position())
			projectile_instance.player_speed = player.velocity
			add_child(projectile_node)
			player.inventory.use_active_item(1)
	if player.inventory.active_item_left == 0:
		chemical_state_chart.send_event("to_default")

func _on_foam_state_exited():
	automatic_fire = false
	player.projectile_scene = load("res://entities/projectiles/WaterProjectile.tscn")
	chemical_state_chart.send_event("to_default")
