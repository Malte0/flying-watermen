class_name Player extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var heat_component: HeatComponent = $HeatComponent
@onready var ranged_component: RangedComponent = $RangedComponent
var shoot_position: Marker2D:
	get: return ranged_component.shoot_position
@onready var melee_attack: MeleeComponent = $MeleeComponent
@onready var interact_component: InteractComponent = $InteractComponent
@onready var inventory: Inventory = $Inventory
@onready var state_chart: StateChart = %StateChart
@onready var animation_tree: AnimationTree = $Animation/AnimationTree
@onready var particle: Node2D = $Particles

# save location
var save_file_path: String = "user://save/"
var save_file_name: String = "PlayerSave.tres"
var player_data: PlayerData = PlayerData.new()

# Reset values
var base_scale_speed: float = 2
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
var projectile_scene: PackedScene = load("res://entities/projectiles/WaterProjectile.tscn")
var direction: float = 0.0
var slide_threshold: float = base_speed/2
var abilities: Dictionary = {
	"dash": false
}

func _ready():
	animation_tree.active = true
	#Initialize values so Guards don't complain
	set_expressions()
	#preparations for saveing
	verify_save_directory(save_file_path)

func _input(event: InputEvent):
	if event.is_action_pressed("interact"):
		interact_component.interact()
	if event.is_action_pressed("jump"):
		state_chart.send_event("jump")
	if event.is_action_pressed("lshift"):
		dash()
	if event.is_action_pressed("attack"):
		melee()
	if event.is_action_pressed("right_click"):
		shoot()
	if event.is_action_pressed("savePlayer"):
		save_Player()
	if event.is_action_pressed("loadPlayer"):
		load_player()

func set_expressions():
	state_chart.set_expression_property("crouching", Input.is_action_pressed("s"))
	state_chart.set_expression_property("jumps_left", jumps_left)
	state_chart.set_expression_property("over_slide_threshold", abs(velocity.x) > slide_threshold)
	state_chart.set_expression_property("velocity_x", velocity.x)

func flip_player():
	scale.x *= -1

func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)

func save_Player():
	update_player_data()
	ResourceSaver.save(player_data, save_file_path + save_file_name)
	print("save")

func update_player_data():
	player_data.update_pos(self.position)
	player_data.set_storedheat(heat_component.get_heat())
	player_data.set_storedhealth(health_component.get_health())
	player_data.set_storedabilities(abilities)

func load_player():
	player_data = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	update_Player_on_load()
	print("loaded")

func update_Player_on_load():
	self.position = player_data.stored_pos
	heat_component.set_heat(player_data.stored_heat)
	health_component.set_health(player_data.stored_health)
	health_component.update_healthbar()
	abilities = player_data.stored_abilities

func disenable_components(ranged: bool, melee: bool, movement: bool):
	ranged_component.is_enabled = ranged
	melee_attack.is_enabled = melee
	if movement: enable_movement()
	else: disable_movement()

func _on_death():
	get_tree().change_scene_to_file.call_deferred(Globals.game_over)

#region PhysicsProcess
func _physics_process(delta: float):
	update_states()
	movement(delta)
	move_and_slide()
	update_animation_parameters()

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

func movement(delta: float):
	# handle left/right movement
	direction = Input.get_axis("a", "d")
	if abs(direction) > 0 and can_move:
		velocity.x = lerp(velocity.x, direction * speed, 0.1)
		if sign(scale.y) != sign(direction) and sign(direction) != 0: flip_player()
	elif abs(velocity.x) < 0.1:
		velocity.x = 0
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	# Gravity
	if not (is_on_floor() and velocity.y == 0):
		velocity.y += gravity * delta * fall_speed_factor

func update_animation_parameters():
	animation_tree.set("parameters/Default/blend_position", abs(velocity.x) > 0.8)
	state_chart.send_event("tick")
#endregion

#region Movement
func reset_variables():
	speed = base_speed
	jump_velocity = base_jump_velocity
	friction = base_friction
	fall_speed_factor = base_fall_speed_factor
	can_move = true
	collision_mask = 0b101
	collision_layer = 0b10

func dash():
	if abilities.dash:
		state_chart.send_event("dash")

func reset_jumps():
	jumps_left = jumps

func disable_movement():
	state_chart.send_event("disable")

func enable_movement():
	state_chart.send_event("enable")

func _on_disabled_state_entered() -> void:
	can_move = false

func _on_crouching_state_entered():
	speed = base_speed/2

func _on_sliding_state_entered():
	friction = base_friction/50
	can_move = false

func _on_jumping_state_entered():
	#velocity.y = jump_velocity + velocity.y/2
	velocity.y = jump_velocity
	jumps_left -= 1

func _on_wall_slide_state_entered():
	reset_jumps()
	velocity.y = velocity.y/10
	fall_speed_factor = base_fall_speed_factor/10

func _on_airborne_state_entered():
	friction = base_friction/10

# Reset variables of any child states of the Movement state
func _on_movement_child_state_exited():
	reset_variables()

func _on_dash_state_entered() -> void:
	particle.dash_trail()
	can_move = false
	friction = 0
	@warning_ignore("narrowing_conversion")
	velocity.x = signi(scale.y) * base_speed * 2
	health_component.is_invincible = true
	collision_mask = 0b1
	collision_layer = 0b

func _on_dash_state_exited() -> void:
	health_component.is_invincible = false

func _on_grounded_state_entered() -> void:
	reset_jumps()
#endregion

#region Melee
func melee():
	melee_attack.attack()
#endregion

#region Shooting
func shoot():
	var shoot_direction = shoot_position.global_position.direction_to(get_global_mouse_position())
	return ranged_component.shoot(shoot_direction, projectile_scene, velocity)
#endregion
