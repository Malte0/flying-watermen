extends CharacterBody2D

const BASE_SPEED = 100
const AGGRO_SPEED = 400
const DIR_CHANGE_PROB = 0.01

const JUMP_VELOCITY = -500
const JUMP_COOLDOWN = 0.5
var last_jump = 0

var calm_direction = -1

var isAggro = false

# reverse dependency?
@onready var player: CharacterBody2D = get_tree().get_root().get_node("Main").get_node("Player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if isAggro:
		aggro_movement()
	else:
		calm_movement()
		
	if is_on_wall():
		jump()
	last_jump += delta
	
	move_and_slide()

func jump():
	if last_jump > JUMP_COOLDOWN:
		velocity.y = JUMP_VELOCITY
		last_jump = 0

func calm_movement():
	var random = randf()
	if random < DIR_CHANGE_PROB:
		calm_direction *= -1
	velocity.x = BASE_SPEED * calm_direction;

func aggro_movement():
	var aggro_direction = sign(player.global_position.x - global_position.x)
	velocity.x = AGGRO_SPEED * aggro_direction;

func _on_aggro_collider_body_entered(body: CharacterBody2D):
	isAggro = true

func _on_aggro_collider_body_exited(body: CharacterBody2D):
	isAggro = false
