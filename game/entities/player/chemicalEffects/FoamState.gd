extends Node2D

@export var player: Player
@export var chemical_state_chart: StateChart

var automatic_fire: bool = false
var automatic_cooldown: float = 0.0

func _ready():
	pass


func _on_foam_state_entered():
	automatic_fire = true
	player.projectile_scene = load("res://entities/projectiles/FoamProjectile.tscn")


func _on_foam_state_processing(delta):
	if automatic_fire and Input.is_action_pressed("right_click"):
		automatic_cooldown += delta
		if automatic_cooldown > 0.07:
			automatic_cooldown -= 0.07
			var projectile_node: Node2D = player.projectile_scene.instantiate()
			var projectile_instance: Projectile = projectile_node.get_node("Projectile")
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
