extends Button

func _ready():
	var button = $"."
	button.set("custom_minimum_size", Vector2(120, 32))
	button.connect("mouse_entered", play_sound.bind())

func play_sound():
	%AudioStreamPlayer.stream = load("res://assets/SFX/player/ui-hover.wav")
	%AudioStreamPlayer.play() 
