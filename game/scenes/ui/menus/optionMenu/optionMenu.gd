class_name OptionsMenu extends Control

@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var menu_bus_id = AudioServer.get_bus_index("Menu")

@onready var music_slider: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer/MusicSlider
@onready var sfx_slider: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer/SFXSlider
@onready var menu_slider: HSlider = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer/MenuSlider
@onready var fullscreen_check_button: CheckButton = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer/FullscreenCheckButton

# saving data
var save_file_path: String = "user://save/"
var save_file_name: String = "OptionSave.tres"
var optionData: OptionData = OptionData.new()

func _ready():
	verify_save_dirctory(save_file_path)
	load_saved_options()
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_id))
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_id))
	menu_slider.value = db_to_linear(AudioServer.get_bus_volume_db(menu_bus_id))
	fullscreen_check_button.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func verify_save_dirctory(path: String):
	DirAccess.make_dir_absolute(path)

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_id, value < 0.001)
	optionData.save_music = music_slider.value

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_id, value < 0.001)
	optionData.save_sfx = sfx_slider.value

func _on_menu_slider_value_changed(value):
	AudioServer.set_bus_volume_db(menu_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(menu_bus_id, value < 0.001)
	optionData.save_menu_sound = menu_slider.value

func _on_fullscreen_check_button_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	optionData.save_fullscreen = fullscreen_check_button.button_pressed

func update_save_options_data():
	optionData.save_fullscreen = fullscreen_check_button.button_pressed
	optionData.save_music = music_slider.value
	optionData.save_sfx = sfx_slider.value
	optionData.save_menu_sound = menu_slider.value

func _on_reset_settings_button_pressed():
	optionData.reset_values()
	update_fullscreen(optionData.deafault_fullscreen)
	update_music_slider(optionData.deafault_music)
	update_sfx_slider(optionData.deafault_sfx)
	update_menu_slider(optionData.deafault_menu_sound)

func load_saved_options():
	if FileAccess.file_exists(save_file_path + save_file_name):
		optionData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		update_fullscreen(optionData.save_fullscreen)
		update_music_slider(optionData.save_music)
		update_sfx_slider(optionData.save_sfx)
		update_menu_slider(optionData.save_menu_sound)

func update_menu_slider(value: float):
	_on_menu_slider_value_changed(value)
	menu_slider.value = db_to_linear(AudioServer.get_bus_volume_db(menu_bus_id))

func update_sfx_slider(value: float):
	_on_sfx_slider_value_changed(value)
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_id))

func update_music_slider(value: float):
	_on_music_slider_value_changed(value)
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_id))

func update_fullscreen(is_fullscreen: bool):
	_on_fullscreen_check_button_toggled(is_fullscreen)
	fullscreen_check_button.button_pressed = (DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_back_button_pressed():
	update_save_options_data()
	ResourceSaver.save(optionData, save_file_path + save_file_name)
	print("saved")
	get_parent().switch_window("menu")
