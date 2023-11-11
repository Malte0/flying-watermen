extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
	get_tree().root.content_scale_factor = 6


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
