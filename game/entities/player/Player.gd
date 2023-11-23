extends CharacterBody2D

## Emitted when this node is clicked with a mouse
#signal clicked(node:Node2D)

#func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
#	# if the left mouse button is up emit the clicked signal
#	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() == false:
#			clicked.emit(self)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_chart: StateChart = $StateChart
@onready var wall_check: RayCast2D = $WallCheck
#@onready var animation_tree: AnimationTree = $AnimationTree
#@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

# Reset values
var base_scale_speed: float = 2.5
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
var air_jumps_left = air_jumps
var fall_speed_factor = base_fall_speed_factor
var can_move: bool = true

func reset_variables():
	speed = base_speed
	jump_velocity = base_jump_velocity
	friction = base_friction
	air_jumps_left = air_jumps
	fall_speed_factor = base_fall_speed_factor
	can_move = true

# Other information about the player
const SPRITE_FLIP_OFFSET: int = 0
var direction: float = 0.0
var slide_threshold: float = base_speed/2


func _ready():
#	animation_tree.active = true
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
	
	move_and_slide()


func _input(event):
	if event.is_action_pressed("w"):
		state_chart.send_event("wPressed")


func update_animation():
#	animation_tree.set("parameters/Crouch/Crouch/blend_position", abs(velocity.x) > 1)
#	animation_tree.set("parameters/Move/blend_position", abs(velocity.x) > 1)
	# If player walks in different direction
	if (sprite.flip_h and direction > 0 and velocity.x > 0) or (not sprite.flip_h and direction < 0 and velocity.x < 0):
		flip_sprite()


func flip_sprite():
	wall_check.position.x = -wall_check.position.x
	if sprite.flip_h:
		turn_around(SPRITE_FLIP_OFFSET)
	elif not sprite.flip_h:
		turn_around(-SPRITE_FLIP_OFFSET)


func turn_around(move_sprite):
	sprite.flip_h = !sprite.flip_h
	sprite.move_local_x(move_sprite)


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
	if facing_wall(): flip_sprite()


func _on_pressed_state_physics_processing(delta):
	if is_on_floor(): state_chart.send_event("jump")


func _on_airborne_state_entered():
	friction = base_friction/10


# Reset variables of any child states of the Movement state
func _on_movement_child_state_exited():
	reset_variables()
