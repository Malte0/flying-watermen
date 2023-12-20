extends Enemy

@onready var wall_detection: RayCast2D = $DirectionalNodes/wall_detetion
@onready var health_bar: Node2D = $EnemyHealthBar
@onready var nodes_to_flip: Node2D = $DirectionalNodes
@onready var aggro_cooldown: Timer = $AggroCooldown
@onready var player: Player = get_node("/root/Player")

const HEAT_DISTANCE: int = 350
const HEAT_PER_TICK: int = 2
const DAMAGE_DISTANCE: int = 150
const DAMAGE_PER_TICK: int = 2

var is_aggro: bool = false
var movement_speed_aggro: int = 250
var movement_speed_calm: int = 100

func _init():
	var max_health: int = 100
	super(max_health)
	movement_speed = movement_speed_calm
	move(Movement_Direction.Right)

func _physics_process(delta):
	hunt_player() if is_aggro else idle()
	super(delta)

func hunt_player():
	if wall_detection.is_colliding():
		jump(1)
	
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
	if body is Player:
		aggro_cooldown.stop()
		if not is_aggro:
			player = body
			# Expermiment: This introduces some anticipation into the behaviour
			jump(0.2)
			movement_speed = 0
			await get_tree().create_timer(0.4).timeout
			movement_speed = movement_speed_aggro
	is_aggro = true

func _on_player_detection_range_body_exited(body):
	aggro_cooldown.start()

func _on_damage_tick_timeout():
	if player == null:
		return
	var player_distance = player.global_position.x - global_position.x
	if abs(player_distance) < DAMAGE_DISTANCE:
		var damage_amount: int = ceili(((DAMAGE_DISTANCE - abs(player_distance)) / DAMAGE_DISTANCE) * DAMAGE_PER_TICK)
		player.take_damage(damage_amount, Element.Fire)
	if abs(player_distance) < HEAT_DISTANCE:
		var heat_amount: int = ceili(((HEAT_DISTANCE - abs(player_distance)) / HEAT_DISTANCE) * HEAT_PER_TICK)
		player.increase_heat(heat_amount)

func _on_aggro_cooldown_timeout():
	is_aggro = false
	movement_speed = movement_speed_calm
