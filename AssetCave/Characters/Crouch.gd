extends BaseState

@export var crouch_speed = speed/2
const CROUCH_START = "parameters/conditions/crouch_start"
const CROUCH_END = "parameters/conditions/end_crouch"

# Called when the state machine enters this state.
func on_enter():
	tree.set(CROUCH_START, true)
	tree.set(CROUCH_END, false)


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	if !Input.is_action_pressed("s"):
		state_machine.current_state = idle_state
	elif abs(dir) > 0:
		player.velocity.x = lerp(player.velocity.x, dir * crouch_speed, 0.1)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, 1.0)
	super.on_physics_process(delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	tree.set(CROUCH_START, false)
	tree.set(CROUCH_END, true)

