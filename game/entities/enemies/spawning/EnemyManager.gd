class_name EnemyManager extends Node2D

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var spawn_timer: Timer = $SpawnRate

@onready var ENEMY_SPAWN_PROBABILITIES: Dictionary = {
	"rangedEnemy": {
		"weight": 0.3,
		"scene": load("res://entities/enemies/rangedEnemy/RangedEnemy.tscn")
	},
	"meleeEnemy": {
		"weight": 0.7,
		"scene": load("res://entities/enemies/meleeEnemy/MeleeEnemy.tscn")
	},
}

#region Test
func test_enemy_probabilities():
	var total_probability: float = 0
	for key in ENEMY_SPAWN_PROBABILITIES:
		var enemy: Dictionary = ENEMY_SPAWN_PROBABILITIES[key]
		if not enemy["weight"]:
			push_warning("Weight missing in "+key)
			continue
		if not enemy["scene"]:
			push_warning("Scene missing in "+key)
			continue
		total_probability += enemy["weight"]
	if abs(total_probability-1) > 0.01:
		push_warning("Weights don't add up to 1 but " + str(total_probability))
#endregion

func _ready():
	test_enemy_probabilities()
	spawn_timer.timeout.connect(func(): spawn_random_enemy(Vector2(player.global_position.x, 0)))

func spawn_random_enemy(position: Vector2):
	var random: float = randf()
	var current_prob: float = 0
	for key in ENEMY_SPAWN_PROBABILITIES:
		var enemy_type: Dictionary = ENEMY_SPAWN_PROBABILITIES[key]
		current_prob += enemy_type["weight"]
		if random < current_prob:
			var enemy_instance: Enemy = enemy_type["scene"].instantiate()
			enemy_instance.global_position = position
			get_parent().add_child.call_deferred(enemy_instance)
			return
