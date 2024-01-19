extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Ice.state_entered.connect(_on_ice_state_entered)
	%Water.state_entered.connect(_on_water_state_entered)

func _on_ice_state_entered() -> void:
	$ice.visible = true
	$default.visible = false

func _on_water_state_entered() -> void:
	$ice.visible = false
	$default.visible = true
