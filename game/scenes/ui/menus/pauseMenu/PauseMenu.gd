extends Control

var is_paused: bool = false:
	set = set_paused

func _ready():
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		is_paused = !is_paused

func set_paused(is_value: bool) -> void:
	is_paused = is_value
	get_tree().paused = is_paused
	visible = is_paused

func _on_resume_pressed() -> void:
	is_paused = false

func _on_menu_pressed() -> void:
	is_paused = false
	get_tree().change_scene_to_file.call_deferred(Globals.main_menu)

func _on_quit_pressed() -> void:
	get_tree().quit()
