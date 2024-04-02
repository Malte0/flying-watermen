extends Node2D

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

func _on_audio_stream_player_finished():
	$Environment/AudioStreamPlayer.play()


func _on_area_2d_2_body_entered(body):
	if body is Player:
		$Environment/AudioStreamPlayer.volume_db = -1000

func _on_area_2d_3_body_entered(body):
	if body is Player:
		$Environment/AudioStreamPlayer.volume_db = 0
