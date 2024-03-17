class_name MainMenu extends Control

func _on_start_button_pressed() -> void:
	Globals.load_with_loading_screen(Globals.main_scene)

func _on_option_button_pressed() -> void:
	get_parent().switch_window("option")
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()