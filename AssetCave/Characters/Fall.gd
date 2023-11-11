extends BaseState

const END_FALL = "parameters/conditions/end_fall"

# Called when the state machine enters this state.
func on_enter():
	tree.set(END_FALL, false)
	tree_state_machine.travel("Fall")


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
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
	if event.is_action_pressed("w"):
		double_jump()


# Called when the state machine exits this state.
func on_exit():
	tree.set(END_FALL, true)

