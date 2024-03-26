class_name MainMenu extends Control

func _on_start_pressed() -> void:
	Globals.load_with_loading_screen(Globals.main_scene)

func _on_option_pressed() -> void:
	get_parent().switch_window("option")
	
func _on_quit_pressed() -> void:
	get_tree().quit()
