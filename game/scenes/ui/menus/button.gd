extends Button
@onready var audioPlayer : AudioStreamPlayer = %AudioStreamPlayer

func _ready():
	var button = $"."
	button.set("custom_minimum_size", Vector2(120, 32))
	button.connect("mouse_entered", play_sound.bind())

func play_sound():
	audioPlayer.stream = load("res://assets/SFX/player/ui-hover.wav")
	audioPlayer.volume_db = 0
	audioPlayer.play()
	
	
