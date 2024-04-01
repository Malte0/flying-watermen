extends Resource
class_name  PlayerData

@export var stored_abilities: Dictionary = {
	"dash": false
	}
@export var filled_wells: Dictionary = {}
@export var stored_pos: Vector2

func set_storedabilities(value: Dictionary):
	stored_abilities = value

func update_pos(value: Vector2):
	stored_pos = value

func update_filled_wells(value: Vector2):
	if not filled_wells.has(value):
		filled_wells[value] = value
