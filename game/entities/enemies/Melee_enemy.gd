extends Node2D

const COLOR_CALM: Color = Color(0.71, 0.325, 0.325)
const COLOR_AGGRO: Color = Color(0.71, 0.156, 0.156)

@onready var body = $"CharacterBody2D"
@onready var colorBody = $"CharacterBody2D/Dummy_body"

# Called when the node enters the scene tree for the first time.
func _ready():
	changeColor(COLOR_CALM)

func _on_area_2d_body_entered(body):
	print("Detected Player")
	aggro()

func changeColor(color: Color):
	colorBody.modulate = color

func deaggro():
	print("deaggro")
	changeColor(COLOR_CALM)
	$StateChart.send_event("deaggro")

func aggro():
	print("aggro")
	changeColor(COLOR_AGGRO)
	$StateChart.send_event("player_detected")


func _on_area_2d_body_exited(body):
	deaggro()
