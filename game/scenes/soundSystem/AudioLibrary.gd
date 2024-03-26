extends Resource
class_name AudioLibrary

@export var sound_effects: Array[SoundEffect]

func get_audio_stream(_tag: String):
	var index = -1 
	if _tag:
		for sound in sound_effects:
			index += 1
			if sound.tag == _tag:
				break
		return sound_effects[index].stream
	else:
		printerr("not tag, cannot get sound effect")
	return null
