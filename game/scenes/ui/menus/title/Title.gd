extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene_to_file.call_deferred(Globals.main_menu)
