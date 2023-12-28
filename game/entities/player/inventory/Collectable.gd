class_name Collectable extends CharacterBody2D

@export var collect_area: Area2D
@export var item: Item
const COLLECT_DURATION: float = 0.03
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	collect_area.body_entered.connect(_body_entered)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()

func _body_entered(body):
	if body is Player:
		body.inventory.set_item_in_inventory(item)
		var tween = create_tween()
		tween.tween_property(self, "position", body.position, COLLECT_DURATION)
		tween.tween_property(self, "scale", Vector2.ZERO, COLLECT_DURATION)
		tween.finished.connect(queue_free)
