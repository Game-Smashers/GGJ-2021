extends Room

class_name WaterPumpRoom

var broken_down := false
var seconds_until_fixed := 0.0
const seconds_to_fix := 4.0

var seconds_since_break_down := 0.0
var seconds_until_next_break_down := 0.0

func _ready():
	randomize()
	on_restart()


func break_down():
	broken_down = true
	seconds_until_fixed = seconds_to_fix
	seconds_since_break_down = 0.0


func on_fixed():
	broken_down = false
	seconds_until_fixed = 0.0
	seconds_until_next_break_down = float(randi() % 5 + 10)


func _process(delta):
	if broken_down:
		if occupants.size() > 0:
			var undazed_occupant_count := get_undazed_occupant_count()
			seconds_until_fixed -= undazed_occupant_count * delta
			if seconds_until_fixed < 0.0:
				on_fixed()

		var alpha = clamp(seconds_until_fixed / seconds_to_fix, 0.0, 1.0)
		var col_mul = lerp(Color.white, Color(0.8, 0.1, 0.1, 1.0), alpha)
		material.set_shader_param("col_mul", col_mul)
	else:
		seconds_since_break_down += delta
		if seconds_since_break_down >= seconds_until_next_break_down:
			break_down()

		material.set_shader_param("col_mul", Color(1, 1, 1, 1))


func on_restart():
	.on_restart()
	on_fixed()
	material.set_shader_param("col_mul", Color(1, 1, 1, 1))

