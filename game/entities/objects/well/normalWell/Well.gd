extends Interactable

@onready var sprite: Sprite2D = $Texture

const FULL_TEXTURE = preload("res://entities/objects/well/assets/wellFull.png")
const EMPTY_TEXTURE = preload("res://entities/objects/well/assets/wellEmpty.png")

var is_full: bool = false
signal well_filled()

func _ready() -> void:
	interact_hint = $RichTextLabel
	Globals.load.connect(load_well)

## Fills the well, but only once
func fill_well(_body: Node, save = true):
	if not is_full:
		$CollisionShape2D.disabled = true
		sprite.texture = FULL_TEXTURE
		$GPUParticles2D.visible  = true
		well_filled.emit()
		is_full = true
		Globals.save.emit(position.x, position.y)
		Globals.check_win.emit()

func load_well(xpos: float, ypos: float):
	if is_equal_approx(position.x, xpos) and is_equal_approx(position.y, ypos):
		fill_well(null, false)
