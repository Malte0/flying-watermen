extends Area2D

var interactables_in_range: Array = []
var has_interactable: bool = false
var current_closest_node: Interactable = null:
	set(value):
		if current_closest_node != null: current_closest_node.disable_pick_up_hint()
		current_closest_node = value
		if current_closest_node: current_closest_node.enable_pick_up_hint()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and current_closest_node != null:
		if current_closest_node is Collectable:
			current_closest_node.collect(get_parent())

func _process(delta: float) -> void:
	var closest_node = get_closest_node()
	if not closest_node == current_closest_node:
		current_closest_node = closest_node

func get_closest_node():
	var closest_node: Interactable = null
	var closest_distance: float
	for node: Interactable in interactables_in_range:
		var distance: float = global_position.distance_to(node.global_position)
		if not closest_node or distance < closest_distance:
			closest_node = node
			closest_distance = distance
	return closest_node

func _on_area_entered(area: Area2D) -> void:
	if area is Interactable:
		interactables_in_range.append(area)

func _on_area_exited(area: Area2D) -> void:
	if interactables_in_range.has(area):
		interactables_in_range.erase(area)
