class_name Player extends CharacterBody2D

@onready var inventory: Inventory = $Inventory
@onready var health_component: HealthComponent = $HealthComponent
@onready var heat_component: HeatComponent = $HeatComponent
@onready var ranged_component: RangedComponent = %RangedComponent
@onready var state_chart: StateChart = $StateChart

var projectile_scene: PackedScene = load("res://entities/projectiles/WaterProjectile.tscn")

# Reset values
var base_scale_speed: float = 1.5
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") * base_scale_speed
var base_speed: float = 300.0 * base_scale_speed
var base_jump_velocity: float = -400.0 * base_scale_speed
var base_friction: float = 0.5
var base_fall_speed_factor: float = 1.0
var jumps: int = 2
# Resettable variables
var scale_speed: float = base_scale_speed
var speed: float = base_speed
var jump_velocity: float = base_jump_velocity
var friction: float = base_friction
var fall_speed_factor: float = base_fall_speed_factor
var can_move: bool = true
var jumps_left: int = jumps

# Other information about the player
var direction: float = 0.0
var slide_threshold: float = base_speed/2

func set_expressions():
	state_chart.set_expression_property("crouching", Input.is_action_pressed("s"))
	state_chart.set_expression_property("jumps_left", jumps_left)
	state_chart.set_expression_property("over_slide_threshold", abs(velocity.x) > slide_threshold)
	state_chart.set_expression_property("velocity_x", velocity.x)

func reset_variables():
	speed = base_speed
	jump_velocity = base_jump_velocity
	friction = base_friction
	fall_speed_factor = base_fall_speed_factor
	can_move = true
	collision_mask = 0b101
	collision_layer = 0b10

func _ready():
	health_component.death.connect(_on_death)
	#Initialize values so Guards don't complain
	set_expressions()

## Callback for player interaction
var on_interact = func(): print("Nothing to interact")

func apply_gravity(delta: float):
	if is_on_floor() and velocity.y == 0:
		jumps_left = jumps
	else:
		velocity.y += gravity * delta * fall_speed_factor
		if is_on_wall() and (Input.is_action_pressed("a") or Input.is_action_pressed("d")):
			jumps_left = jumps
			
func update_states():
	set_expressions()
	# For transitions without event condition
	state_chart.send_event("tick")
	if is_on_floor() and velocity.y == 0:
		state_chart.send_event("grounded")
	if velocity.y > 0:
		if is_on_wall() and (Input.is_action_pressed("a") or Input.is_action_pressed("d")):
			state_chart.send_event("wall_slide")
		else:
			state_chart.send_event("falling")

func movement():
	if direction == 0:
		velocity.x = lerp(velocity.x, 0.0, friction)
	# handle left/right movement
	direction = Input.get_axis("a", "d")
	if abs(direction) > 0 and can_move:
		velocity.x = lerp(velocity.x, direction * speed, 0.1)
		if sign(scale.y) != sign(direction) and sign(direction) != 0: flip_player()
	elif abs(velocity.x) < 0.1:
		velocity.x = 0
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

func _physics_process(delta: float):
	movement()
	apply_gravity(delta)
	move_and_slide()
	update_states()

func _input(event: InputEvent):
	if event.is_action_pressed("attack"):
		state_chart.send_event("attackpressed")
	if event.is_action_pressed("interact"):
		on_interact.call()
	if event.is_action_pressed("jump"):
		state_chart.send_event("jump")
	if event.is_action_pressed("lshift"):
		state_chart.send_event("dash")

func flip_player():
	scale.x *= -1

func _on_crouching_state_entered():
	speed = base_speed/2

func _on_sliding_state_entered():
	friction = base_friction/50
	can_move = false

func _on_jumping_state_entered():
	velocity.y = jump_velocity + velocity.y/2
	jumps_left -= 1

func _on_wall_slide_state_entered():
	velocity.y = velocity.y/10
	fall_speed_factor = base_fall_speed_factor/10

func _on_airborne_state_entered():
	friction = base_friction/10

# Reset variables of any child states of the Movement state
func _on_movement_child_state_exited():
	reset_variables()

func _on_can_shoot_state_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		state_chart.send_event("shoot")
		var direction = global_position.direction_to(get_global_mouse_position())
		ranged_component.shoot(direction, projectile_scene, velocity)

func _on_death():
	get_tree().change_scene_to_file.call_deferred("res://menus/game_over/GameOver.tscn")

func _on_dash_state_entered() -> void:
	can_move = false
	friction = 0
	velocity.x = signi(scale.y) * base_speed * 2
	collision_mask = 0b1
	collision_layer = 0b

func _on_locked_state_entered() -> void:
	can_move = false
