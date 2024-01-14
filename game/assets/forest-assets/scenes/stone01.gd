extends Sprite2D

var rng = RandomNumberGenerator.new()
func _ready():
	var my_random_number = rng.randf_range(0.0, 10.0)
	# rng.randomize()
	material.set("shader_parameter/speed", 10 * my_random_number)
	print(material.get("shader_parameter/speed"))
	print(material.get("shader_parameter/strengthScale"))
	print(my_random_number)
	
