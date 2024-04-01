extends Node2D

func _on_destroyable_wall_3_wall_destroyed():
	$WindTunnels/WindTunnel3/CollisionShape2D.set_deferred("disabled", false)
	$WindTunnels/WindTunnel3.visible = true
