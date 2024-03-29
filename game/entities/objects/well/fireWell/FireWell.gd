extends Area2D

@onready var sprite: Sprite2D = $Texture

var has_enemies_inside: Array[Object] = []
var new_well: PackedScene = load("res://entities/objects/well/normalWell/Well.tscn")

func _ready() -> void:
	Globals.load_firewell.connect(load_firewell)

func _process(delta):
	if has_enemies_inside == []:
		var well_instance: Interactable = new_well.instantiate()
		well_instance.global_position = position
		get_parent().add_child.call_deferred(well_instance)
		queue_free()
	var index: int = 0
	for enemies in has_enemies_inside:
		if str(enemies) == "<Freed Object>": has_enemies_inside.remove_at(index)
		index += 1
	index = 0

func _on_body_entered(body):
	if body is Player: $FillLabel.visible = true
	elif body is CharacterBody2D: has_enemies_inside.append(body)

func _on_body_exited(body):
	if body is Player:
		$FillLabel.visible = false

func load_firewell(pos: Vector2):
	if is_equal_approx(pos.x, position.x) and is_equal_approx(pos.y, position.y):
		var well_instance: Interactable = new_well.instantiate()
		well_instance.global_position = position
		get_parent().add_child.call_deferred(well_instance)
		well_instance.load_well(position)
		queue_free()
