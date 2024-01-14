extends Sprite2D

var rng = RandomNumberGenerator.new()
func _ready():
	material.set("shader_parameter/minStrength", rng.randf_range(0.1, 0.4))
	material.set("shader_parameter/maxStrength", rng.randf_range(0.5,0.7))
	material.set("shader_parameter/speed", rng.randf_range(0.8,1.4))
	material.set("shader_parameter/heightOffset", 0.6)
