extends BaseState


# Called when the state machine enters this state.
func on_enter():
	tree.set("parameters/conditions/turn_around", true)


# Called every frame when this state is active.
func on_process(delta):
	pass


# Called every physics frame when this state is active.
func on_physics_process(delta):
	if abs(dir) > 0:
		player.velocity.x = lerp(player.velocity.x, dir * speed, 0.03)
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.5)
	super.on_physics_process(delta)


# Called when there is an input event while this state is active.
func on_input(event: InputEvent):
	pass


# Called when the state machine exits this state.
func on_exit():
	tree.set("parameters/conditions/turn_around", false)


func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "turn_around":
		if abs(player.velocity.x) > 0.005:
			state_machine.current_state = run_state
		else:
			state_machine.current_state = idle_state
