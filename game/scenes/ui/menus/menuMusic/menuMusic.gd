extends AudioStreamPlayer

@onready var menu_music = preload("res://assets/SFX/worldMusic/Ambient 5.wav")

func play_music(music: AudioStream):
	if stream == music: 
		return
	stream = music
	play()
	
func play_music_menu():
	play_music(menu_music)
	
func stop_music_menu():
	stream = null