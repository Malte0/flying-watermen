class_name Interactable extends Area2D

var interact_hint: Control = null

func enable_interact_hint():
	interact_hint.visible = true

func disable_interact_hint():
	interact_hint.visible = false

func interact(interactor: Node):
	push_error(name + ": Interact function not implemented!")
