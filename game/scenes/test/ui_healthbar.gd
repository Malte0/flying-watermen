extends CanvasLayer

@export var player : Player

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Panel/Healthbar").setPlayer(player)
	get_node("Panel2/Heatbar").setPlayer(player)
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass