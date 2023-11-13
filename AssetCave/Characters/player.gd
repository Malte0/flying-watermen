extends CharacterBody2D

## Emitted when this node is clicked with a mouse 
#signal clicked(node:Node2D)


#	# set the velocity to the animation tree, so it can blend between animations
#	_animation_tree["parameters/Move/blend_position"] = signf(velocity.y)
#
#
#func _on_double_jump_state_event_received(event:StringName):
#	# if we get an event "jump" while in the double jump state we play the double jump animation
#	if event == "jump":
#		# print("playing double jump")
#		_animation_state_machine.travel("DoubleJump")


#func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
#	# if the left mouse button is up emit the clicked signal
#	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed() == false:
#			clicked.emit(self)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_chart: StateChart = $StateChart
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float = 0.0
var can_move: bool = true
var slide_threshold: float = base_speed/2

@export var base_speed: float = 300.0
@export var base_jump_velocity: float = -400.0
@export var base_friction: float = 0.5
@export var air_jumps: int = 1
var speed: float = base_speed
var jump_velocity: float = base_jump_velocity
var friction: float = base_friction
var air_jumps_left: int = air_jumps

func _ready():
	animation_tree.active = true


func _physics_process(delta):
	# Debug Info
	state_chart.set_expression_property("velocity_x", velocity.x)
	
	# For transitions without event condition
	state_chart.send_event("tick")
	
	# handle left/right movement
	direction = Input.get_axis("a", "d")
	if abs(direction) > 0 and can_move:
		velocity.x = lerp(velocity.x, direction * speed, 0.1)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
	
	# handle gravity
	if is_on_floor() and velocity.y >= 0:
		state_chart.send_event("grounded")
		air_jumps_left = air_jumps 
	else:
		velocity.y += gravity * delta
		if velocity.y > 0:
			state_chart.send_event("falling")
	
	
	if Input.is_action_just_pressed("w"): state_chart.send_event("jump")
	
	state_chart.set_expression_property("crouching", Input.is_action_pressed("s"))
	state_chart.set_expression_property("air_jumps_left", air_jumps_left)
	state_chart.set_expression_property("over_slide_threshold", abs(velocity.x) > slide_threshold)
	
	update_animation()
	move_and_slide()


func update_animation():
	animation_tree.set("parameters/Crouch/Crouch/blend_position", direction)
	animation_tree.set("parameters/Move/blend_position", direction)
	if sprite.flip_h and direction > 0 and velocity.x > 0:
		turn_around(10)
	elif not sprite.flip_h and direction < 0 and velocity.x < 0:
		turn_around(-10)


func turn_around(move_sprite):
	sprite.flip_h = !sprite.flip_h
	sprite.move_local_x(move_sprite)


func _on_crouching_state_entered():
	speed = base_speed/2


func _on_crouching_state_exited():
	speed = base_speed


func _on_sliding_state_entered():
	friction = base_friction/50
	can_move = false


func _on_sliding_state_exited():
	friction = base_friction
	can_move = true


func _on_airborne_state_input(event):
	if Input.is_action_just_pressed("w") and air_jumps_left > 0: air_jumps_left -= 1


func _on_jumping_state_entered():
	velocity.y = jump_velocity + velocity.y/2
