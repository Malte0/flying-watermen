extends TextureProgressBar

var player: Player
var health: HealthComponent:
	get: return player.health_component

# Called when the node enters the scene tree for the first time.
func _ready():
	value = 100.0
	tint_progress = Color("blue")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	print(player)
	value = health.current_health * 100 / health.max_health
	get_node("HEALTH_Lable").text = str(health.current_health) + " / " + str(health.max_health)
	tint_progress = Color("blue").lerp(Color("red"), float(player.heat) / float(player.max_heat))
