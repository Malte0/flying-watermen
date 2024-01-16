extends Enemy

@onready var aggro_cooldown_timer: Timer = $AggroCooldown
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var ground_distance: RayCast2D = $GroundDistance
@onready var ranged_component: RangedComponent = $RangedComponent

var projectile_scene: PackedScene = load("res://entities/projectiles/FireProjectile.tscn")
const SHOOTING_PRECISION: float = PI/10 # Angle in radians that gets randomly applied to shots
const JUMP_FORCE: int = -150
const MOVEMENT_SPEED_CALM: int = 100
const MOVEMENT_SPEED_AGGRO: int = 250
var is_aggro: bool = false

func _ready():
	movement_speed = MOVEMENT_SPEED_CALM
	move(Movement_Direction.Right)

func _physics_process(delta):
	if is_aggro:
		hunt_player()
	if ground_distance.is_colliding():
		velocity.y = JUMP_FORCE
	super(delta)

func hunt_player():
	var player_distance: float = player.global_position.x - global_position.x
	var player_direction: int = sign(player_distance)
	if abs(player_distance) < 20: # this is just some random small value
		movement_direction = Movement_Direction.No
		return
	if player_direction != movement_direction:
		flip_move_direction()

func flip_move_direction():
	if movement_direction == Movement_Direction.Left:
		move(Movement_Direction.Right)
	else:
		move(Movement_Direction.Left)
	scale.x = movement_direction

func _on_view_area_body_entered(body):
	if body is Player:
		become_aggro()

func _on_view_area_body_exited(body):
	if body is Player and aggro_cooldown_timer.is_inside_tree():
		aggro_cooldown_timer.start()

func _on_aggro_cooldown_timeout():
	is_aggro = false
	movement_speed = MOVEMENT_SPEED_CALM

func become_aggro():
	aggro_cooldown_timer.stop()
	is_aggro = true
	movement_speed = MOVEMENT_SPEED_AGGRO

func _on_health_component_health_changed(_new_health, delta_health):
	if delta_health < 0:
		become_aggro()

func _on_direction_change_timeout() -> void:
	if not is_aggro:
		flip_move_direction()

func _on_fire_rate_timeout() -> void:
	if is_aggro:
		var random_angle: float = randf()*SHOOTING_PRECISION - (SHOOTING_PRECISION/2)
		var new_direction = position.direction_to(player.position).rotated(random_angle)
		ranged_component.shoot(new_direction, projectile_scene, velocity)
