class_name Collectable extends Interactable

@export var item: Item

const COLLECT_DURATION: float = 0.03

func _ready():
	pick_up_hint = $PanelContainer
	pick_up_hint.visible = false

func collect(collector: Player):
	collector.inventory.set_item_in_inventory(item)
	var tween = create_tween()
	tween.tween_property(get_parent(), "position", collector.position, COLLECT_DURATION)
	tween.tween_property(get_parent(), "scale", Vector2.ZERO, COLLECT_DURATION)
	tween.finished.connect(get_parent().queue_free)

func enable_pick_up_hint():
	pick_up_hint.visible = true

func disable_pick_up_hint():
	pick_up_hint.visible = false
