extends TextureProgressBar

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var health_label: Label = $HealthLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	player.health_component.health_change.connect(_on_player_health_change)
	value = 100

func _on_player_health_change(new_health: int, _delta_health: int):
	@warning_ignore("integer_division")
	value = new_health * 100 / player.health_component.max_health
	health_label.text = str(new_health) + " / " + str(player.health_component.max_health)

func _process(_delta):
	tint_progress = Color("blue").lerp(Color("red"), player.heat / float(player.max_heat))
