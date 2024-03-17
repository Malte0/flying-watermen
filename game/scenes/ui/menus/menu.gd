class_name Menu extends Control

@onready var main: MainMenu = $Main
@onready var option: OptionsMenu = $Options

func _ready():
	MenuMusic.play_music_menu()

func _on_tree_exiting() -> void:
	MenuMusic.stop_music_menu()

func switch_window(window: String):
	if window == "option":
		main.visible = false
		option.visible = true
	if window == "menu": 
		main.visible = true
		option.visible = false
