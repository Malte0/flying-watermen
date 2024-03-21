extends Area2D

@onready var player = get_tree().get_first_node_in_group("Player")

func _on_body_entered(body):
	if body is Player:
		body.gravity *= -0.25
		body.velocity.y = minf(body.velocity.y, body.velocity.y/2)


func _on_body_exited(body):
	if body is Player:
		body.gravity *= -4
