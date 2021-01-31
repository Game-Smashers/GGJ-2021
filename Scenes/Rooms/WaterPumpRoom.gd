extends Room

class_name WaterPumpRoom

var broken_down := false
var seconds_until_fixed := 0.0
const seconds_to_fix := 4.0

var seconds_since_break_down := 0.0
var seconds_until_next_break_down := 0.0

onready var fixed_sound = preload("res://Audio/SFX/Fixed.wav")
onready var fixing_sound = preload("res://Audio/SFX/RepairNoises.wav")
onready var fixing_player = AudioStreamPlayer.new()

var disable_breakdown := false

func _ready():
	add_child(fixing_player)
	fixing_player.stream = fixing_sound
	randomize()
	on_restart()


func break_down():
	if not disable_breakdown:
		broken_down = true
		seconds_until_fixed = seconds_to_fix
		seconds_since_break_down = 0.0


func on_fixed(first_time = false):
	if (!first_time):
		play_fixed_sound()
	broken_down = false
	seconds_until_fixed = 0.0
	if not disable_breakdown:
		seconds_until_next_break_down = float(randi() % 5 + 10)


func _process(delta):
	if game_is_paused:
		return

	if not disable_breakdown:
		if broken_down:
			if occupants.size() > 0:
				if (!fixing_player.playing):
					fixing_player.play()
				var undazed_occupant_count := get_undazed_occupant_count()
				seconds_until_fixed -= undazed_occupant_count * delta
				if seconds_until_fixed < 0.0:
					on_fixed()
					fixing_player.stop()

			# Always show some red to make fixed state clearer
			var alpha = clamp(seconds_until_fixed / seconds_to_fix * 0.5 + 0.5, 0.0, 1.0)
			var col_mul = lerp(Color.white, Color(0.8, 0.1, 0.1, 1.0), alpha)
			material.set_shader_param("col_mul", col_mul)
		else:
			seconds_since_break_down += delta
			if seconds_since_break_down >= seconds_until_next_break_down:
				break_down()
			material.set_shader_param("col_mul", Color(1, 1, 1, 1))
	else:
		material.set_shader_param("col_mul", Color(1, 1, 1, 1))

func on_restart():
	.on_restart()
	on_fixed(true)
	broken_down = false
	seconds_until_fixed = 0.0
	seconds_since_break_down = 0.0
	seconds_until_next_break_down = float(randi() % 5 + 10)
	material.set_shader_param("col_mul", Color(1, 1, 1, 1))

func play_fixed_sound():
	play_sound(fixed_sound)
	pass

func play_sound(audio_stream):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = audio_stream
	player.play()
	yield(player, "finished")
	remove_child(player)
	player.queue_free()
