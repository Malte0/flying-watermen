extends BaseState

class_name Jump

const START_JUMP = "parameters/conditions/start_jump"
const END_JUMP = "parameters/conditions/end_jump"
#const START_FALL = "parameters/Jump/conditions/start_fall"

# Called when the state machine enters this state.
func on_enter():
	if !can_jump:
		state_machine.previous_state()
	player.velocity.y = player.temp_jump_velocity
	player.temp_jump_velocity = player.jump_velocity
	tree.set(END_JUMP, false)
	tree.set(START_JUMP, true)


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	if abs(dir) > 0:
		player.velocity.x = lerp(player.velocity.x, air_speed * dir, 0.1)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.02)
	
	super.on_physics_process(delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if event.is_action_pressed("w"):
		double_jump()


# Called when the state machine exits this state.
func on_exit():
	tree.set(END_JUMP, true)
	tree.set(START_JUMP, false)
