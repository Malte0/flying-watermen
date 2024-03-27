extends Interactable

signal read(reader: Node2D)

@onready var stone_tablet_content = get_parent().get_node("StoneTabletOverlay")

func _ready():
	interact_hint = %EKeyDark
	$AnimationPlayer.play("hover")

func read_stone_tablet(reader: Node):
	stone_tablet_content.visible = true
	$CollisionShape2D/GPUParticles2D.visible = false
	read.emit(reader)
