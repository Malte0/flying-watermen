extends Enemy

@onready var wall_detection = $DirectionalNodes/wall_detetion
@onready var health_bar = $EnemyHealthBar
@onready var nodes_to_flip: Node2D = $DirectionalNodes
var player: Player = null # change dependency
const DAMAGE_PER_TICK = 2

const DAMAGE_DISTANCE = 200
const HEAT_DISTANCE = 300
const HEAT_PER_TICK = 3

#var can_see_player: bool = false
var is_hunting: bool = false

func _init():
	var max_health = 100
	super(max_health)
	move(Movement_Direction.Right)

func _physics_process(delta):
	if is_hunting:
		hunt_player()
	else:
		idle()
	super(delta)

func hunt_player():
	if player == null:
		return
	var player_distance = player.global_position.x - global_position.x
	var player_direction = sign(player_distance)
	if abs(player_distance) < 20: # this is just some random small value
		if movement_direction != Movement_Direction.No:
			movement_direction = Movement_Direction.No
		return
	if player_direction != movement_direction:
		flip_move_direction()

func idle():
	if wall_detection.is_colliding():
		flip_move_direction()

func flip_move_direction():
	if movement_direction == Movement_Direction.Left:
		move(Movement_Direction.Right)
	else:
		move(Movement_Direction.Left)
	nodes_to_flip.scale.x = movement_direction

func _on_change_health(new_health):
	health_bar.change_health(new_health)

func _on_player_detection_range_body_entered(body):
	is_hunting = true
	if body is Player:
		player = body
		movement_speed = 200

func _on_player_detection_range_body_exited(body):
	is_hunting = false
	movement_speed = 100

func _on_damage_tick_timeout():
	if player == null:
		return
	var player_distance = player.global_position.x - global_position.x
	if abs(player_distance) < DAMAGE_DISTANCE:
		player.take_damage(DAMAGE_PER_TICK, Element.Fire)
	if abs(player_distance) < HEAT_DISTANCE:
		player.increase_heat(HEAT_PER_TICK)
