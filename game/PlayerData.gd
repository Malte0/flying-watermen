extends Resource
class_name  PlayerData

@export var stored_abilities: Dictionary = {
	"dash": false,
	"building_foam": false,
	"double_jump": false
	}
@export var filled_wells: Dictionary = {}
@export var eaten_plants: Dictionary = {}
@export var stored_pos: Vector2

func set_storedabilities(value: Dictionary):
	stored_abilities = value

func update_pos(value: Vector2):
	stored_pos = value

func update_filled_wells(value: Vector2):
	if not filled_wells.has(value):
		filled_wells[value] = value

func update_eaten_plants(value: Vector2):
	if not eaten_plants.has(value):
		eaten_plants[value] = value
