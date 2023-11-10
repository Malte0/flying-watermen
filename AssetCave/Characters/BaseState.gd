extends State

class_name BaseState

@onready var player: CharacterBody2D = $"../.."
@onready var tree = $"../../AnimationTree"
@onready var sprite = $"../../AnimatedSprite2D"
@onready var anim_player = $"../../AnimationPlayer"
@onready var tree_state_machine = $"../../AnimationTree".get("parameters/playback")

@onready var idle_state: State = $"../Idle"
@onready var jump_state: State = $"../Jump"
@onready var run_state: State = $"../Run"
@onready var crouch_state: State = $"../Crouch"
@onready var slide_state: State = $"../Slide"
@onready var turn_around_state: State = $"../TurnAround"

@export var can_move = true
@export var can_jump = true
@export var speed = 300.0
@export var jump_velocity = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dir = 0.0

func _ready():
	tree.active = true


# Called when the state machine enters this state.
func on_enter():
	pass


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	dir = Input.get_axis("a", "d")
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity.y += gravity * delta

	if player.position.x < -200:
		player.position.x = 600
	update_animation()
	player.move_and_slide()


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	pass


func update_animation():
	tree.set("parameters/crouch/Crouch/blend_position", dir)
	tree.set("parameters/Move/blend_position", dir)
	if state_machine.current_state != turn_around_state: update_orientation()
	
func update_orientation():
	if sprite.flip_h and dir > 0:
		turn_around(10)
	elif not sprite.flip_h and dir < 0:
		turn_around(-10)

func turn_around(move_sprite):
	sprite.flip_h = !sprite.flip_h
	sprite.move_local_x(move_sprite)
