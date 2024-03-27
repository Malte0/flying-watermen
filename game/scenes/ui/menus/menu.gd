class_name Menu extends Control

@onready var main: MainMenu = $MainMenu
@onready var option: OptionsMenu = $Options
@onready var menu_audio_player: AudioStreamPlayer = $MenuAudioPlayer
@onready var menu_music = preload("res://assets/SFX/worldMusic/Ambient 5.wav")

func _ready():
	menu_audio_player.stream = menu_music
	menu_audio_player.play()

func _on_tree_exiting() -> void:
	menu_audio_player.stop()

func switch_window(window: String):
	if window == "option":
		main.visible = false
		option.visible = true
	if window == "menu": 
		main.visible = true
		option.visible = false
