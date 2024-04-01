extends Node2D

@onready var vision_obstacle: PointLight2D = $Player/PointLight2D2

func _on_destroyable_wall_3_wall_destroyed():
	$WindTunnels/WindTunnel3/CollisionShape2D.set_deferred("disabled", false)
	$WindTunnels/WindTunnel3.visible = true

func blinging_player(body):
	if body is Player:
		pass
		#vision_obstacle.visible = true

func give_vision_to_player(body):
	if body is Player:
		pass
		#vision_obstacle.visible = false
