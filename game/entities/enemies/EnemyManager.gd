extends Node2D

@onready var enemies: Array[Node] = get_tree().get_nodes_in_group("Enemy")

func _ready():
	for e in enemies:
		var enemy = e as Enemy
		enemy.health_component.death.connect(_on_enemy_death)

func _on_enemy_death():
	print("Someone died")
	# if one dies spawn a new one
