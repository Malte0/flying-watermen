class_name FireWave extends Node

@export var damage: int = 40
@export var life_time: float = 2
@export var circle_width: int

@onready var timer = $Timer
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var OUTER_RADIUS: int = $Sprite2D.texture.get_width() / 2
@onready var INNER_RADIUS: int = OUTER_RADIUS - circle_width

const START_SIZE: float = 0.5
const SIZE_GROWTH: float = 0.04
var current_scale
var tics_per_life_time: int
var outer_radius: int
var inner_radius: int
var did_dmg: bool = false


func _ready():
	current_scale = START_SIZE
	change_scale()
	tics_per_life_time = life_time / timer.wait_time
	
func change_scale():
	self.scale.x = current_scale
	self.scale.y = current_scale
	inner_radius = INNER_RADIUS * current_scale
	outer_radius = OUTER_RADIUS * current_scale

func _on_timer_timeout():		
	current_scale += SIZE_GROWTH
	change_scale()
	if not did_dmg:
		deal_dmg()
	tic_down()
	
func tic_down():
	tics_per_life_time -= 1
	if tics_per_life_time <= 0:
		queue_free()
		
func deal_dmg():
	var player_distance: int = (player.global_position - self.global_position).length()
	if inner_radius <= player_distance && player_distance <= outer_radius:
		var HealthComponent = player.get_node("HealthComponent")
		HealthComponent.take_damage(damage, Element.Type.Fire)
		did_dmg = true
		
