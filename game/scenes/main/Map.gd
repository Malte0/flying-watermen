extends Node2D

@onready var vison_obstacle: Sprite2D = $Player/Camera2D/BlockVision

func _on_destroyable_wall_3_wall_destroyed():
	$WindTunnels/WindTunnel3/CollisionShape2D.set_deferred("disabled", false)

func _on_blind_begining_body_entered(body):
	blinging_player(body)

func _on_vision_beginning_body_entered(body):
	give_vision_to_player(body)

func _on_bilnd_ending_body_entered(body):
	blinging_player(body)

func _on_vision_ending_body_entered(body):
	give_vision_to_player(body)

func blinging_player(body):
	if body is Player:
		vison_obstacle.visible = true

func give_vision_to_player(body):
	if body is Player:
		vison_obstacle.visible = false
