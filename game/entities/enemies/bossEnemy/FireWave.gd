class_name FireWave extends Node

@export var damage: int = 40
@export var life_time: int = 4

const START_SIZE: int = 1
const SIZE_GROWTH: float = 0.05
var current_scale

func _ready():
	current_scale = START_SIZE
	change_scale()
	
func change_scale():
	self.scale.x = current_scale
	self.scale.y = current_scale

func _on_timer_timeout():		
	current_scale += SIZE_GROWTH
	change_scale()
