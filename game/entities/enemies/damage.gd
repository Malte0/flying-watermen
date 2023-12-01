extends Node2D

# damage over distance
const MAX_DAMAGE_DISTANCE = 300
const DISTANCE_STEP = 100
const DISTANCE_DAMAGE = 2

# reverse dependencies here?
@onready var player: CharacterBody2D = get_tree().get_root().get_node("Main").get_node("Player")
@onready var thisBody: CharacterBody2D = $"CharacterBody2D"

func _physics_process(delta):
	var this_position = thisBody.global_position
	var player_position = player.global_position
	var distanceToPlayer = this_position.distance_to(player_position)
	if distanceToPlayer < MAX_DAMAGE_DISTANCE:
		deal_distance_damage(distanceToPlayer)

func deal_distance_damage(distanceToPlayer: float):
	var damage: int = floor((DISTANCE_STEP/distanceToPlayer) * DISTANCE_DAMAGE)
	print("deal ", damage, " damage to Player")

