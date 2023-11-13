extends ColorRect

var direction = 1
@onready var cat = $Background2/NyanCat

# Called when the node enters the scene tree for the first time.
func _ready():
	cat.play("rocket")
	cat.position.y = rand()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	randomize()
	cat.move_local_x(2*direction)
	if cat.position.x > 600 and direction == 1:
		cat.flip_h = true
		direction = -1
		cat.position.y = rand()
	elif cat.position.x < -600 and direction == -1:
		cat.flip_h = false
		direction = 1
		cat.position.y = rand()

func rand():
	return randi_range(-200, 100)
