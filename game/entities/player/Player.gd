class_name Player extends DamageAbleEntity

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_chart: StateChart = $StateChart
@onready var wall_check: RayCast2D = $WallCheck
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var health_bar: TextureProgressBar = $PlayerUI/HealthBar
@onready var heat_bar: ProgressBar = $PlayerUI/HeatBar

const ProjectileScene := preload("res://entities/Projectiles/projectile.tscn")
@onready var shoot_position = $ShootPosition

# Reset values
var base_scale_speed: float = 1.5
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * base_scale_speed
var base_speed: float = 300.0 * base_scale_speed
var base_jump_velocity: float = -400.0 * base_scale_speed
var base_friction: float = 0.5
var air_jumps: int = 1
var base_fall_speed_factor: float = 1.0
# Resettable variables
var scale_speed = base_scale_speed
var speed = base_speed
var jump_velocity = base_jump_velocity
var friction = base_friction
var fall_speed_factor = base_fall_speed_factor
var can_move: bool = true

##############
@onready var Heat_reduction_delay = $Timers/HeatReductionDelay
@onready var Heat_damage_tick = $Timers/HeatTick
@onready var Heal_tick = $Timers/HealTick

const max_heat: int = 100
const heat_damage_threshold: int = 90
const heat_damage_per_second: int = 4
const heat_reduction_rate: int = 4
var heat: int = 0

const Heal_over_time_step = 5
var heal_over_time_left = 0

func _init():
	var max_health = 100
	super(Element.Water, max_health)

# Called to increase the players heat
func increase_heat(amount: int):
	heat = mini(heat + amount, max_heat)
	Heat_reduction_delay.start()
	update_heat_bar(heat)

# Signal called by the heat tick timer
func _on_heat_tick_timeout():
	if heat >= heat_damage_threshold:
		take_damage(heat_damage_per_second, Element.Fire)
	if Heat_reduction_delay.is_stopped():
		heat = maxi(heat - heat_reduction_rate, 0)
		update_heat_bar(heat)

func update_heat_bar(new_heat: int):
	heat_bar.value = new_heat

# Regenerates healthAmount across healthAmount // Heal_over_time_step seconds
func heal_over_time(healthAmount: int):
	heal_over_time_left = healthAmount

# Heals the player for healthAmount during duration seconds
func _on_heal_tick_timeout():
	if heal_over_time_left > 0:
		var amountToHeal = mini(heal_over_time_left, Heal_over_time_step)
		restore_health(amountToHeal)
		heal_over_time_left = maxi(heal_over_time_left - Heal_over_time_step, 0)

func reset_variables():
	speed = base_speed
	jump_velocity = base_jump_velocity
	friction = base_friction
	fall_speed_factor = base_fall_speed_factor
	can_move = true

# Other information about the player
var air_jumps_left = air_jumps
const SPRITE_FLIP_OFFSET: int = 0
var direction: float = 0.0
var slide_threshold: float = base_speed/2

func _ready():
	animation_tree.active = true
	#Initialize values so Guards don't complain
	state_chart.set_expression_property("crouching", Input.is_action_pressed("s"))
	state_chart.set_expression_property("air_jumps_left", air_jumps_left)
	state_chart.set_expression_property("over_slide_threshold", abs(velocity.x) > slide_threshold)
	state_chart.set_expression_property("velocity_x", velocity.x)

func _physics_process(delta):
	# Debug Info
	state_chart.set_expression_property("velocity_x", velocity.x)
	state_chart.set_expression_property("is_on_wall", is_on_wall())
	
	# For transitions without event condition
	state_chart.send_event("tick")
	
	# handle gravity
	if is_on_floor() and velocity.y == 0:
		state_chart.send_event("grounded")
		air_jumps_left = air_jumps
	else:
		velocity.y += gravity * delta * fall_speed_factor
		if velocity.y > 0:
			if is_on_wall() and (Input.is_action_pressed("a") or Input.is_action_pressed("d")):
				state_chart.send_event("wall_slide")
				air_jumps_left = air_jumps
			else:
				state_chart.send_event("falling")

	if Input.is_action_just_pressed("w"): state_chart.send_event("jump")

	state_chart.set_expression_property("crouching", Input.is_action_pressed("s"))
	state_chart.set_expression_property("air_jumps_left", air_jumps_left)
	state_chart.set_expression_property("over_slide_threshold", abs(velocity.x) > slide_threshold)

	update_animation()

	# handle left/right movement
	direction = Input.get_axis("a", "d")
	if abs(direction) > 0 and can_move:
		velocity.x = lerp(velocity.x, direction * speed, 0.1)
	elif abs(velocity.x) < 0.1:
		velocity.x = 0
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		
	if(Input.is_action_just_pressed("right_click")): state_chart.send_event("_on_shot")
	
	move_and_slide()

func _input(event: InputEvent):
	if event.is_action_pressed("w"):
		state_chart.send_event("wPressed")
	if event.is_action_pressed("attack"):
		state_chart.send_event("attackpressed")

func update_animation():
	animation_tree.set("parameters/Action/blend_position", abs(velocity.x) > 0)
	# If player walks in different direction than sprite orienation		
	if (scale.y > 0 and direction < 0 and velocity.x < 0) or (scale.y < 0 and direction > 0 and velocity.x > 0):
		flip_player()

func flip_player():
	scale.x *= -1

func facing_wall():
	return wall_check.is_colliding()

func _on_crouching_state_entered():
	speed = base_speed/2

func _on_sliding_state_entered():
	friction = base_friction/50
	can_move = false

func _on_airborn_not_coyote_state_input(_event):
	if Input.is_action_just_pressed("w") and air_jumps_left > 0: air_jumps_left -= 1

func _on_jumping_state_entered():
	velocity.y = jump_velocity + velocity.y/2

func _on_wall_slide_state_entered():
	velocity.y = velocity.y/10
	fall_speed_factor = base_fall_speed_factor/10
	#if facing_wall(): flip_player()

func _on_pressed_state_physics_processing(_delta):
	if is_on_floor(): state_chart.send_event("jump")

func _on_airborne_state_entered():
	friction = base_friction/10

# Reset variables of any child states of the Movement state
func _on_movement_child_state_exited():
	reset_variables()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Hit"):
		#can_move = false
		body.take_damage()
	else:
		pass # Replace with function body.

@onready var shape = $AtkShape

func _on_meele_attacks_child_state_entered():
	$AtkShape/CollisionShape2D.disabled = false

func _on_meele_attacks_child_state_exited():
	$AtkShape/CollisionShape2D.disabled = true

func _on_cant_shoot_state_entered():
	var projectile_instance := ProjectileScene.instantiate()
	projectile_instance.position = shoot_position.global_position
	projectile_instance.direction = global_position.direction_to(get_global_mouse_position())
	add_child(projectile_instance)

func _on_entity_death():
	get_tree().change_scene_to_file.call_deferred("res://menus/game_over/GameOver.tscn")

func _on_change_health(new_health):
	health_bar.value = new_health

