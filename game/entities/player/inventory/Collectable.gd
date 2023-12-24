class_name Collectable extends CharacterBody2D

@export var item: Item
const COLLECT_DURATION: int = 0.5

func _on_collect_detector_body_entered(body):
	if body is Player:
		body.inventory.add_item(item)
		var tween = create_tween()
		await tween.tween_property(self, "position", body.position, COLLECT_DURATION)
		queue_free()
