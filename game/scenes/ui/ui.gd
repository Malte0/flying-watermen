extends CanvasLayer

@onready var debugger: Control = %Debugger
@onready var player: Player = get_tree().get_first_node_in_group("player")

func _ready():
	debugger.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f3"):
		debugger.visible = not debugger.visible

func _physics_process(_delta):
	player.state_chart.set_expression_property("velocity_x", player.velocity.x)
	player.state_chart.set_expression_property("is_on_wall", player.is_on_wall())
