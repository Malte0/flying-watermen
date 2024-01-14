extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Forest/Stone/Stone01.material.set("shader_parameter/speed", 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
