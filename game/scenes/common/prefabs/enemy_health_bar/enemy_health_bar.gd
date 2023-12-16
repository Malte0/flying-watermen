extends Node

@onready var health_bar: TextureProgressBar = $TextureProgressBar

var target_value: int = 100
const interpolation_speed: int = 100

func _process(delta):
	if target_value != health_bar.value:
		var sig = sign(target_value - health_bar.value)
		health_bar.value += sig * delta * interpolation_speed

func change_health(new_health):
	target_value = new_health
