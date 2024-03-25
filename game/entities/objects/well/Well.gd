extends Interactable

@onready var sprite: Sprite2D = $Texture

const FULL_TEXTURE = preload("res://entities/objects/well/assets/wellFull.png")
const EMPTY_TEXTURE = preload("res://entities/objects/well/assets/wellEmpty.png")

var is_full: bool = false
signal well_filled()

var can_be_filled: bool = false
var enemies_inside: Array[Object] = []

func _ready() -> void:
	interact_hint = $FillLabel
	$GPUParticles2D.visible  = false
	$GPUParticles2D2.visible = true

## Fills the well, but only once
func fill_well(_body: Node):
	if not is_full and can_be_filled:
		sprite.texture = FULL_TEXTURE
		$GPUParticles2D.visible  = true
		well_filled.emit()
		is_full = true

func _on_enemyzone_body_entered(body):
	enemies_inside.append(body)

func _process(delta):
	if enemies_inside == []:
		$GPUParticles2D2.visible = false
		$Flamme.visible = false
		can_be_filled = true
		var was_visible: bool = interact_hint.visible
		interact_hint.visible = false
		interact_hint = $RichTextLabel
		if was_visible: interact_hint.visible = true
	var index: int = 0
	for enemies in enemies_inside:
		if str(enemies) == "<Freed Object>": enemies_inside.remove_at(index)
		index += 1
	index = 0
