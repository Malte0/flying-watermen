extends TextureProgressBar

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var health_label: Label = $HealthLabel
@onready var max_health = player.health_component.max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_component.health_change.connect(_on_player_health_change)
	value = 100

func _on_player_health_change(new_health: int, delta_health: int):
	value = (new_health / max_health) * 100
	health_label.text = str(new_health) + " / " + str(max_health)

func _process(_delta):
	tint_progress = Color("blue").lerp(Color("red"), player.heat / player.max_heat)
