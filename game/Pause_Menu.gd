extends Control

var _is_paused: bool = false:
	set = set_paused

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused

func set_paused(_is_value: bool) -> void:
	_is_paused = _is_value
	get_tree().paused = _is_paused
	visible = _is_paused

func _on_resume_button_pressed():
	_is_paused = false

func _on_return_to_menu_button_pressed():
	_is_paused = false
	get_tree().change_scene_to_file.call_deferred(Globals.main_menu)

func _on_quit_game_button_pressed():
	get_tree().quit()
