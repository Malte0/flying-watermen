extends Enemy

@onready var nodes_to_flip: Node2D = $DirectionalNodes
@onready var wall_detection: RayCast2D = $DirectionalNodes/WallDetection
@onready var aggro_cooldown_timer: Timer = $AggroCooldown
@onready var player: Player = get_tree().get_first_node_in_group("player")

const HEAT_RADIUS: int = 350
const HEAT_PER_TICK: int = 2
const DAMAGE_RADIUS: int = 150
const DAMAGE_PER_TICK: int = 1

const MOVEMENT_SPEED_CALM: int = 100
const MOVEMENT_SPEED_AGGRO: int = 250
var is_aggro: bool = false

func _init():
	movement_speed = MOVEMENT_SPEED_CALM
	move(Movement_Direction.Right)

func _physics_process(delta):
	hunt_player() if is_aggro else idle()
	super(delta)

func hunt_player():
	if wall_detection.is_colliding():
		jump(1)
	
	var player_distance = player.global_position.x - global_position.x
	var player_direction = sign(player_distance)
	if abs(player_distance) < 20: # this is just some random small value
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

func scale_by_distance(max_distance: int, player_distance: float, value_to_scale: int):
	return ceili(((max_distance - abs(player_distance)) / max_distance) * value_to_scale)

func _on_damage_tick_timeout():
	var player_distance = player.global_position.x - global_position.x
	if abs(player_distance) < DAMAGE_RADIUS:
		var damage: int = scale_by_distance(DAMAGE_RADIUS, player_distance, DAMAGE_PER_TICK)
		player.health_component.take_damage(damage, Element.Type.Fire)
	if abs(player_distance) < HEAT_RADIUS:
		var heat: int = scale_by_distance(HEAT_RADIUS, player_distance, HEAT_PER_TICK)
		player.increase_heat(heat)

func _on_view_area_body_entered(body):
	if body is Player:
		become_aggro()

func _on_view_area_body_exited(body):
	if body is Player:
		aggro_cooldown_timer.start()

func _on_aggro_cooldown_timeout():
	is_aggro = false
	movement_speed = MOVEMENT_SPEED_CALM

func become_aggro():
	aggro_cooldown_timer.stop()
	if not is_aggro:
		is_aggro = true
		# Expermiment: This introduces some anticipation into the behaviour
		jump(0.2)
		movement_speed = 0
		await get_tree().create_timer(0.4).timeout
		movement_speed = MOVEMENT_SPEED_AGGRO

func _on_health_component_health_change(_new_health, delta_health):
	if delta_health < 0:
		become_aggro()
