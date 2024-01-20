extends Node

var main_scene: NodePath = "res://scenes/test/map.tscn"
var test_scene: NodePath = "res://scenes/test/test.tscn"
var game_over: NodePath = "res://scenes/ui/menus/gameOver/GameOver.tscn"
var main_menu: NodePath = "res://scenes/ui/main_menu.tscn"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("str+1"):
		get_tree().change_scene_to_file.call_deferred(main_scene)
	if event.is_action_pressed("str+2"):
		get_tree().change_scene_to_file.call_deferred(test_scene)
	if event.is_action_pressed("str+r"):
		get_tree().reload_current_scene()
