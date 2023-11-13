extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.content_scale_factor = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_play_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://Menus/options_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
