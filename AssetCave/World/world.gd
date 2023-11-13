extends Node2D

@onready var camera = $Player/Camera2D
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
	get_tree().root.content_scale_factor = 6
	camera.set_zoom(Vector2(1, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.position.x < -200:
		player.position.x = 600
	
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
