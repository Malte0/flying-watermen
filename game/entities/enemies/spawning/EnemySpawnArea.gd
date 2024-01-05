extends Area2D

@onready var enemy_manager: EnemyManager = get_tree().get_first_node_in_group("EnemyManager")
@onready var collision_shape: CollisionShape2D = get_children()[0]

const MAX_SPAWN_ATTEMPTS: int = 10
const MIN_SPAWN_DISTANCE_TO_PLAYER: int = 300

func _on_body_entered(body: Node2D):
	if body is Player:
		attempt_enemy_spawn(body)

# attempts to spawn enemy with min distance to player
func attempt_enemy_spawn(player: Player):
	for i in range(MAX_SPAWN_ATTEMPTS):
		var random_position: Vector2 = get_random_position_in_area()
		var distance_to_player: float = random_position.distance_to(player.global_position)
		if distance_to_player < MIN_SPAWN_DISTANCE_TO_PLAYER:
			continue
		enemy_manager.spawn_random_enemy(random_position)
		return

# returns a random coordinate in collision_shapes area
func get_random_position_in_area():
	var collision_boundary: Rect2 = collision_shape.shape.get_rect()
	var lower_x: float = collision_shape.global_position.x + collision_boundary.position.x
	var lower_y: float = collision_shape.global_position.y + collision_boundary.position.y
	var upper_x: float = lower_x + collision_boundary.size.x
	var upper_y: float = lower_y + collision_boundary.size.y
	@warning_ignore("narrowing_conversion")
	return Vector2(randi_range(lower_x, upper_x), randi_range(lower_y, upper_y))
