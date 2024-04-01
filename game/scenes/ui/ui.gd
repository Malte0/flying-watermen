extends CanvasLayer

@onready var debugger: Control = $StateChartDebugger
@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var foam: Sprite2D = %Foam
@onready var water: Sprite2D = %Water

func _ready():
	visible = true
	debugger.debug_node(player.state_chart)
	debugger.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f3"):
		debugger.visible = !debugger.visible
	if event.is_action_pressed("swap_shoot_type") and player.abilities.building_foam:
		if water.visible:
			water.visible = false
			foam.visible = true
		else:
			water.visible = true
			foam.visible = false

func _physics_process(_delta):
	player.state_chart.set_expression_property("velocity_x", player.velocity.x)
	player.state_chart.set_expression_property("is_on_wall", player.is_on_wall())
	$Swap.visible = player.abilities.building_foam
