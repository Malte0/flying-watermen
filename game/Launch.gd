extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var window_size_percentage = 0.6
	var screen_size = DisplayServer.screen_get_size()
	var screen = DisplayServer.window_get_current_screen()
	DisplayServer.window_set_size(screen_size * window_size_percentage)
	DisplayServer.window_set_position((screen_size * (1-window_size_percentage)) / 2)
	DisplayServer.window_set_current_screen(screen)
	get_tree().change_scene_to_file.call_deferred(Globals.main_scene)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
