extends Node

@onready var polyphonic_audio_player: AudioStreamPlayer = $PolyphonicAudioPlayer

var item_in_inventory: String = ""

# jump sound
func _on_jumping_state_entered():
	polyphonic_audio_player.play_sound_effect_from_library("jump")

#dash sound
func _on_dash_state_entered():
	polyphonic_audio_player.play_sound_effect_from_library("dash")

# pick up sound
func _on_inventory_on_item_in_inventory_updated(new_item, old_item):
	if !new_item == null:
		polyphonic_audio_player.play_sound_effect_from_library("pickupItem")

# melee attack sound
func _on_melee_component_melee_attack_started():
	polyphonic_audio_player.play_sound_effect_from_library("melee")

# determin which sound needs to be played for a specific item
func _on_ranged_component_projectile_shoot():
	if item_in_inventory == "foam":
		polyphonic_audio_player.play_sound_effect_from_library("foam")
	if item_in_inventory == "sodium":
		polyphonic_audio_player.play_sound_effect_from_library("sodium")
	else:
		polyphonic_audio_player.play_sound_effect_from_library("shoot")

func _on_inventory_on_item_activated(item):
	if item == null:
		return
	if item.name == "ice":
		polyphonic_audio_player.play_sound_effect_from_library("ice")
	else: item_in_inventory = item.name

func _on_inventory_on_item_used(amount_left, max_amount):
	if amount_left == 0:
		item_in_inventory = ""
