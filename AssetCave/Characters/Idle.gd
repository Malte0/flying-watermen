extends BaseState


# Called when the state machine enters this state.
func on_enter():
	pass


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.5)

	if Input.is_action_pressed("s"):
		state_machine.current_state = crouch_state
	elif abs(dir) > 0:
		state_machine.current_state = run_state
	super.on_physics_process(delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if(event.is_action_pressed("w")) and player.is_on_floor():
		state_machine.current_state = jump_state


# Called when the state machine exits this state.
func on_exit():
	pass
