extends Node2D

@onready var enemies: Array[Node] = get_tree().get_nodes_in_group("Enemy")
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var spawn_timer: Timer = $SpawnRate

const SPAWN_OFFSET: int = 800
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
	spawn_timer.timeout.connect(spawn_enemy)
	for e in enemies:
		var enemy = e as Enemy
		connect_enemy_signals(enemy)
	spawn_enemy()

func connect_enemy_signals(enemy: Enemy):
	enemy.health_component.death.connect(_on_enemy_death)

func _on_enemy_death():
	spawn_enemy()

func spawn_enemy():
	var random: float = randf()
	var current_prob: float = 0
	for key in ENEMY_SPAWN_PROBABILITIES:
		var enemy: Dictionary = ENEMY_SPAWN_PROBABILITIES[key]
		current_prob += enemy["weight"]
		if random < current_prob:
			var enemy_instance: Enemy = enemy["scene"].instantiate()
			var offset: int = SPAWN_OFFSET if randf() < 0.5 else -SPAWN_OFFSET
			enemy_instance.global_position = Vector2(player.global_position.x+offset, player.global_position.y-1000)
			get_parent().add_child.call_deferred(enemy_instance)
			connect_enemy_signals.call_deferred(enemy_instance)
