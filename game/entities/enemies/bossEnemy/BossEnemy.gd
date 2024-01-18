extends Enemy

@onready var nodes_to_flip: Node2D = $DirectionalNodes
@onready var wall_detection: RayCast2D = $DirectionalNodes/WallDetection
@onready var aggro_cooldown_timer: Timer = $AggroCooldown
@onready var player: Player = get_tree().get_first_node_in_group("player")

const JUMP_FORCE: int = -500
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
		jump(JUMP_FORCE)
	var player_distance: float = player.global_position.x - global_position.x
	var player_direction: int = sign(player_distance)
	if abs(player_distance) < 80: # this is just some random small value
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

func _on_view_area_body_entered(body):
	if body is Player:
		print("player entered")
		become_aggro()

func _on_view_area_body_exited(body):
	if body is Player and aggro_cooldown_timer.is_inside_tree():
		aggro_cooldown_timer.start()
		
func _on_aggro_cooldown_timeout():
	is_aggro = false
	movement_speed = MOVEMENT_SPEED_CALM

func become_aggro():
	aggro_cooldown_timer.stop()
	if not is_aggro:
		is_aggro = true
		# Expermiment: This introduces some anticipation into the behaviour
		jump(JUMP_FORCE * 0.2)
		movement_speed = 0
		await get_tree().create_timer(0.4).timeout
		movement_speed = MOVEMENT_SPEED_AGGRO
		
func _on_health_component_health_changed(_new_health, delta_health):
	if delta_health < 0:
		become_aggro()


func _on_health_bar_value_changed(value):
	pass # Replace with function body.
