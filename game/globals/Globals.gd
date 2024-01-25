extends Node

var main_scene = "res://scenes/main/FirstMap.tscn"
var test_scene = "res://scenes/test/test.tscn"
var game_over = "res://scenes/ui/menus/gameOver/GameOver.tscn"
var main_menu = "res://scenes/ui/menus/mainMenu/mainMenu.tscn"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("str+1"):
		get_tree().change_scene_to_file.call_deferred(main_scene)
	if event.is_action_pressed("str+2"):
		get_tree().change_scene_to_file.call_deferred(test_scene)
	if event.is_action_pressed("str+r"):
		get_tree().reload_current_scene()