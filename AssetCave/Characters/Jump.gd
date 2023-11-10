extends BaseState

@export var air_speed = 300
const START_JUMP = "parameters/conditions/start_jump"
const END_JUMP = "parameters/conditions/end_jump"
const START_FALL = "parameters/Jump/conditions/start_fall"

# Called when the state machine enters this state.
func on_enter():
	if !can_jump:
		state_machine.previous_state()
	player.velocity.y = jump_velocity
	tree.set(START_FALL, false)
	tree.set(END_JUMP, false)
	tree.set(START_JUMP, true)


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	if player.velocity.y >= 0:
		tree.set(START_FALL, true)
		
	if abs(dir) > 0:
		player.velocity.x = lerp(player.velocity.x, air_speed * dir, 0.1)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.02)
		
	if player.is_on_floor() and player.velocity.y == 0:
		if Input.is_action_pressed("a") or Input.is_action_pressed("d"):
			state_machine.current_state = run_state
		else:
			state_machine.current_state = idle_state
		
	super.on_physics_process(delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	tree.set(END_JUMP, true)
	tree.set(START_JUMP, false)
