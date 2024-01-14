extends Sprite2D

var rng = RandomNumberGenerator.new()
func _ready():
	material.set("shader_parameter/minStrength", rng.randf_range(0.1, 0.2))
	material.set("shader_parameter/maxStrength", rng.randf_range(0.3,0.5))
	material.set("shader_parameter/speed", rng.randf_range(1.2,1.6))
	material.set("shader_parameter/heightOffset", 0.7)
