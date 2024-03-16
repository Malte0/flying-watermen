extends Interactable

@onready var sprite: Sprite2D = $Texture

const FULL_TEXTURE = preload("res://entities/objects/well/assets/wellFull.png")
const EMPTY_TEXTURE = preload("res://entities/objects/well/assets/wellEmpty.png")

var is_full: bool = false
signal well_filled()

var enemies_in_range: int = 0

var enemies_inside: Array[Object] = []

func _ready() -> void:
	interact_hint = $FillLabel

## Fills the well, but only once
func fill_well(_body: Node):
	if not is_full:
		sprite.texture = FULL_TEXTURE
		$GPUParticles2D.visible  = true
		well_filled.emit()
		is_full = true

func _on_enemyzone_body_entered(body):
	enemies_inside.append(body)

func _process(delta):
	print(enemies_inside)
	for enemies in enemies_inside:
		if str(enemies) == "<Freed Object>":
			enemies_inside.erase(enemies)
