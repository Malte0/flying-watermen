extends BaseState

const START_SLIDE = "parameters/conditions/start_slide"
const END_SLIDE = "parameters/Slide/conditions/slide_end"

# Called when the state machine enters this state.
func on_enter():
	tree.set(START_SLIDE, true)
	tree.set(END_SLIDE, false)


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	player.velocity.x = lerp(player.velocity.x, 0.0, 0.01)
	
	if !Input.is_action_pressed("s"):
		state_machine.current_state = idle_state
	elif abs(player.velocity.x) < 150:
		state_machine.current_state = crouch_state
		
	super.on_physics_process(delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	tree.set(START_SLIDE, false)
	tree.set(END_SLIDE, true)

