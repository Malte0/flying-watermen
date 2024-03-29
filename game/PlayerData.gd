extends Resource
class_name  PlayerData

@export var stored_abilities: Dictionary = {
	"dash": false
	}
@export var can_use_pos: bool = false
@export var stored_pos: Vector2
@export var stored_wells: Dictionary = {}
@export var num_wells_filled: int = 0
@export var is_boss_alive: bool = true

func set_storedabilities(value: Dictionary):
	stored_abilities = value

func update_pos(value: Vector2):
	stored_pos = value

func add_well(xpos: int, ypos: int):
	stored_wells[[xpos, ypos]] = [xpos, ypos]
	num_wells_filled += 1
