class_name MainMenu extends Control

@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button
@onready var option_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Option_Button
@onready var exit_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button

func _ready():
	start_button.button_down.connect(on_start_pressed)
	option_button.button_down.connect(on_option_pressed)
	exit_button.button_down.connect(on_exit_pressed)

func on_start_pressed() -> void:
	Globals.load_with_loading_screen(Globals.main_scene)

func on_option_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menus/optionMenu/optionMenu.tscn")

func on_exit_pressed() -> void:
	get_tree().quit()


