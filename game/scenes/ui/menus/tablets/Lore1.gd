extends Node2D

func _ready() -> void:
	$SequencePlayer.visible = $StoneTabletOverlay.visible

func _on_stone_tablet_overlay_visibility_changed() -> void:
	$SequencePlayer.visible = $StoneTabletOverlay.visible
