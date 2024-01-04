extends CanvasLayer

@onready var debugger: Control = $StateChartDebugger
@onready var player: Player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	debugger.debug_node(player)
	debugger.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f3"):
		debugger.visible = !debugger.visible
