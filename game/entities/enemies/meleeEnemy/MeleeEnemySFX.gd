extends Node2D

@onready var polyphonic_audio_player: AudioStreamPlayer = $PolyphonicAudioPlayer

func _on_melee_component_melee_attack_started():
	polyphonic_audio_player.play_sound_effect_from_library("melee")

# Komisch mit dem Foam
#func _on_health_component_health_changed(new_health, delta_health):
	#polyphonic_audio_player.play_sound_effect_from_library("tookDamage")
