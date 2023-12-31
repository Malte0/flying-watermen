class_name ChemicalStateManager extends Node

@export var chemical_state_chart: StateChart
@export var player: Player
@export var player_sprite_container: Node2D
var tmp_inventory: Dictionary = {
	"active_item": "ice"
}

func _ready():
	chemical_state_chart.set_expression_property("active_chemical", tmp_inventory.active_item)

func _input(event: InputEvent):
	if event.is_action_pressed("activate_chemical_effect"):
		chemical_state_chart.send_event("to_chemical")

func update_player_graphics(effect_name: String):
	var sprites: Array = player_sprite_container.get_children()
	for sprite in sprites:
		sprite.visible = sprite.name == effect_name

func _on_default_state_entered():
	update_player_graphics("default")

func _on_ice_state_entered():
	update_player_graphics("ice")
