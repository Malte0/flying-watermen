extends Area2D

const AMOUNT_TO_HEAL = 25

func _on_body_entered(body):
	if body is Player: 
		body.heal_over_time(AMOUNT_TO_HEAL) 
		queue_free()
