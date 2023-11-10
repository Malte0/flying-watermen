extends BaseState

const START_SLIDE = "parameters/conditions/start_slide"


# Called when the state machine enters this state.
func on_enter():
	tree.set(START_SLIDE, true)


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	
	
	if abs(player.velocity.x) < 0.005:
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
	tree.set(START_SLIDE, false)

