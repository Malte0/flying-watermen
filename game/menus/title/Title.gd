extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().change_scene_to_file.call_deferred("res://scenes/test/test.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
