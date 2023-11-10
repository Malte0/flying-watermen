extends FiniteStateMachine

#@export var character: CharacterBody2D
#
#var states: Array[State]
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	for child in get_children():
#		if child is State:
#			states.append(child)
#			# Setup State
#			child.character = character
#		else:
#			push_warning("Child " + child.name + " is not a State for StateMachine")
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if(current_state.next_state != null):
#		switch_state(current_state.next_state)
#
#
#func switch_state(new_state: State):
#	if(current_state != null):
#		current_state.on_exit()
#		current_state.next_state = null
#
#	current_state = new_state
#	current_state.on_enter()
#
#func _input(event):
#	current_state.state_input(event)
