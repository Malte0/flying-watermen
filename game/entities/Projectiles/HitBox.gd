#HitBox
class_name HitBox
extends Area2D

@export var damage := 1

@onready var collision_shape := $CollisionShape2D

func _init():
	collision_mask = 1
	collision_layer = 2
	
func set_disabled(is_disabled: bool) -> void:
	collision_shape.set_deferred("disabled", is_disabled)
