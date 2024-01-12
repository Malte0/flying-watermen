extends Enemy

@export var aggro_component: AggroComponent
@export var movement_component: MovementComponent
@export var movement_speed_calm: int = 100
@export var movement_speed_aggro: int = 250

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var ground_distance: RayCast2D = $GroundDistance

## When the enemy is directly above the player it stops movement
# idk what to name this...
const MOVEMENT_EPSILON_PIXELS: int = 50

func _ready():
	aggro_component.aggro_entered.connect(on_aggro_entered)
	aggro_component.calm_entered.connect(on_calm_entered)

func _physics_process(delta: float):
	if ground_distance.is_colliding():
		movement_component.jump(1)

	if not aggro_component.is_aggro:
		return

	var player_distance: float = player.global_position.x - global_position.x
	var player_direction: int = sign(player_distance)
	if abs(player_distance) < MOVEMENT_EPSILON_PIXELS:
		movement_component.movement_direction = movement_component.Movement_Direction.No
		return
	if player_direction == movement_component.Movement_Direction.Right:
		movement_component.change_move_direction(movement_component.Movement_Direction.Right)
	else:
		movement_component.change_move_direction(movement_component.Movement_Direction.Left)

func on_aggro_entered():
	movement_component.movement_speed = movement_speed_aggro

func on_calm_entered():
	movement_component.movement_speed = movement_speed_calm
