extends Node

@onready var polyphonic_audio_player: AudioStreamPlayer = $PolyphonicAudioPlayer

var item_sound: String = ""

func _on_inventory_on_item_activated(item):
	if item == null:
		return
	item_sound = item.name 

func _on_inventory_on_item_in_inventory_updated(new_item, old_item):
	if !new_item == null:
		polyphonic_audio_player.play_sound_effect_from_library("pickup_item")

func _on_melee_component_melee_attack_started():
	polyphonic_audio_player.play_sound_effect_from_library("melee")

func _on_ranged_component_projectile_shoot():
	if item_sound == "foam":
		polyphonic_audio_player.play_sound_effect_from_library("foam")
	if item_sound == "sodium":
		polyphonic_audio_player.play_sound_effect_from_library("jump")
	else:
		polyphonic_audio_player.play_sound_effect_from_library("shoot")

func _on_jumping_state_entered():
	polyphonic_audio_player.play_sound_effect_from_library("jump")

func _on_dash_state_entered():
	polyphonic_audio_player.play_sound_effect_from_library("dash")

func _on_inventory_on_item_used(amount_left, max_amount):
	if amount_left == 0:
		item_sound = ""
