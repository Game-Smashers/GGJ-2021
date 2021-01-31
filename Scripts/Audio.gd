extends Node

onready var pickup_sound = preload("res://Audio/SFX/Pickup.wav")
onready var drop_sound = preload("res://Audio/SFX/Pop.wav")

func play_pickup_sound():
	play_sound(pickup_sound)
	pass

func play_drop_sound():
	play_sound(drop_sound)
	pass

func play_sound_from_file(audio_file):
	if File.new().file_exists(audio_file):
		var audio_stream = load(audio_file)
		play_sound(audio_stream)

func play_sound(audio_stream):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = audio_stream
	player.play()
	yield(player, "finished")
	remove_child(player)
	player.queue_free()
