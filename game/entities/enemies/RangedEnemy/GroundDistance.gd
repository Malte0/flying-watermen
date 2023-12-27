@tool
extends RayCast2D

var max_height: int = 1000
var min_height: int = 1000
var old_position = Vector2(0.0, 0.0)
var height:
	get: return target_position.y
	set(value): target_position.y = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	height = 0
	while !is_colliding() and height < max_height:
		height += 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if old_position != position:
			PhysicsServer2D.set_active(true)
			old_position = position
			height = 0
			while !is_colliding() and height < max_height:
				height += 10
			PhysicsServer2D.set_active(false)
