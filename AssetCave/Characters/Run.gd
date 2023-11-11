extends BaseState

const TURN_AROUND = "parameters/Idle_Move/conditions/turn_around"
#var right: bool

# Called when the state machine enters this state.
func on_enter():
	pass
	#right = dir >= 0


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	if abs(dir) > 0:
		player.velocity.x = lerp(player.velocity.x, dir * speed, 0.1)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.5)
	
	if abs(player.velocity.x) < 0.005:
		state_machine.current_state = idle_state
#	elif right != (dir >= 0) and abs(dir) > 0:
#		state_machine.current_state = turn_around_state
#	else: right = dir > 0
	if state_machine.current_state != turn_around_state:
		super.on_physics_process(delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	if event.is_action_pressed("w") and player.is_on_floor():
		state_machine.current_state = jump_state
	elif event.is_action_pressed("s") and player.is_on_floor():
		state_machine.current_state = slide_state


# Called when the state machine exits this state.
func on_exit():
	pass
