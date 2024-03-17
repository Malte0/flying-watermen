extends Control

@onready var back_button = $MarginContainer/HBoxContainer/VBoxContainer/Back_Button
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var menu_bus_id = AudioServer.get_bus_index("Menu")

@onready var music_slider = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer/MusicSlider
@onready var sfx_slider = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer/SFXSlider
@onready var menu_slider = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer/MenuSlider

func _ready():
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_id))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_id))
	menu_slider.value = db_to_linear(AudioServer.get_bus_volume_db(menu_bus_id))

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/menus/mainMenu/mainMenu.tscn")

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_id, value < 0.001)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_id, value < 0.001)

func _on_menu_slider_value_changed(value):
	AudioServer.set_bus_volume_db(menu_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(menu_bus_id, value < 0.001)