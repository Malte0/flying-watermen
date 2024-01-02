extends Node2D

@onready var enemies: Array[Node] = get_tree().get_nodes_in_group("Enemy")
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var spawn_timer: Timer = $SpawnRate

const SPAWN_OFFSET: int = 800
# amount of enemies that will spawn ahead of player vs behind
const SPAWN_POSITION_BIAS: float = 0.7
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
	spawn_timer.timeout.connect(spawn_random_enemy)
	for e in enemies:
		var enemy: Enemy = e as Enemy
		connect_enemy_signals(enemy)
	spawn_random_enemy()

func connect_enemy_signals(enemy: Enemy):
	enemy.health_component.death.connect(_on_enemy_death)

func _on_enemy_death():
	spawn_random_enemy()

func create_enemy_instance(scene: PackedScene) -> Enemy:
	var enemy_instance: Enemy = scene.instantiate()
	var x_offset: int = SPAWN_OFFSET if randf() < SPAWN_POSITION_BIAS else -SPAWN_OFFSET
	var x_position: int = player.global_position.x+x_offset
	var y_position: int = player.global_position.y-1000
	enemy_instance.global_position = Vector2(x_position, y_position)
	return enemy_instance

func spawn_random_enemy():
	var random: float = randf()
	var current_prob: float = 0
	for key in ENEMY_SPAWN_PROBABILITIES:
		var enemy_type: Dictionary = ENEMY_SPAWN_PROBABILITIES[key]
		current_prob += enemy_type["weight"]
		if random < current_prob:
			var enemy_instance: Enemy = create_enemy_instance(enemy_type["scene"])
			get_parent().add_child.call_deferred(enemy_instance)
			connect_enemy_signals.call_deferred(enemy_instance)
