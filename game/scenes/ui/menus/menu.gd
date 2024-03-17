class_name Menu extends Control

func _ready():
	MenuMusic.play_music_menu()

func _on_tree_exiting() -> void:
	MenuMusic.stop_music_menu()
