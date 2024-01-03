extends Node2D

@onready var sprite: Sprite2D = $Texture

const FULL_TEXTURE = preload("res://entities/well/assets/wellFull.png")
const EMPTY_TEXTURE = preload("res://entities/well/assets/wellEmpty.png")

signal well_filled()

func fill_well():
	sprite.texture = FULL_TEXTURE
	well_filled.emit()

func _on_area_2d_body_entered(body):
	if body is Player:
		fill_well()
