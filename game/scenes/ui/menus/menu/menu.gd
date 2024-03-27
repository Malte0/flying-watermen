class_name Menu extends Control

@onready var main: MainMenu = %Main
@onready var option: OptionsMenu = %Options
@onready var menu_audio_player: AudioStreamPlayer = %MenuAudioPlayer
@onready var menu_music = preload("res://assets/SFX/worldMusic/Ambient 5.wav")

func _ready():
	menu_audio_player.stream = menu_music
	menu_audio_player.play()

func _on_tree_exiting() -> void:
	menu_audio_player.stop()

func _on_main_options_pressed() -> void:
	main.visible = false
	option.visible = true

func _on_options_back_pressed() -> void:
	main.visible = true
	option.visible = false
