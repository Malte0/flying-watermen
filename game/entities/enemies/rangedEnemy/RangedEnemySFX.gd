extends Node2D

@onready var polyphonic_audio_player: AudioStreamPlayer = $PolyphonicAudioPlayer

func _on_ranged_component_projectile_shoot():
	polyphonic_audio_player.play_sound_effect_from_library("shoot")

# Komisch mit dem Foam
#func _on_health_component_health_changed(new_health, delta_health):
	#polyphonic_audio_player.play_sound_effect_from_library("tookDamage")
