extends Resource

class_name OptionData

@export var deafault_music: float = 1
@export var deafault_sfx: float = 1
@export var deafault_menu_sound: float = 1
@export var is_deafault_fullscreen: bool = false

@export var save_music: float = 1
@export var save_sfx: float = 1
@export var save_menu_sound: float = 1
@export var is_save_fullscreen: bool = false

func reset_values():
	is_save_fullscreen = is_deafault_fullscreen
	save_menu_sound = deafault_menu_sound
	save_music = deafault_music
	save_sfx = deafault_sfx
