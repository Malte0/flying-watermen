class_name DestroyableWall extends StaticBody2D


@export var sprite: Texture
@export var collision_shape: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = sprite
	$CollisionShape2D.shape = collision_shape.shape
	$Area2D/CollisionShape2D.shape = collision_shape.shape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	if area is Explosion:
		collision_layer = 0
