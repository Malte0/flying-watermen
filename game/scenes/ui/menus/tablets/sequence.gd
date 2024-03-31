extends CanvasLayer

func _ready() -> void:
	visible = false

func _play() -> void:
	visible = true
	$Sequence.play("sequence")
