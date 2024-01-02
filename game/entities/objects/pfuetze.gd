extends Area2D

var health_in_puddle: int = 25

func _on_body_entered(body):
	if body is Player:
		var amount_to_heal: int = body.health_component.max_health - body.health_component.health
		body.heal_over_time(amount_to_heal)
		health_in_puddle -= amount_to_heal
		queue_free()
