extends Room

class_name TurbineRoom

onready var efficiency_progress_bar: ProgressBar = $EfficiencyProgressBar

var efficiency: float = 1.0

const fix_speed := 0.2
const break_down_speed = 0.035
var efficiency_drain_multiplier:= 1.0

var disable_breakdown := false

func _ready():
	randomize()
	on_restart()


func _process(delta):
	if game_is_paused:
		return

	if not disable_breakdown:
		if occupants.size() > 0:
			var undazed_occupant_count := get_undazed_occupant_count()
			efficiency += undazed_occupant_count * delta * fix_speed
		else:
			efficiency -= delta * break_down_speed * efficiency_drain_multiplier
		efficiency = clamp(efficiency, 0.0, 1.0)

		if efficiency < 0.2:
			var alpha = 1.0 - clamp(efficiency / 0.2, 0.0, 1.0)
			var col_mul = lerp(Color.white, Color(0.8, 0.1, 0.1, 1.0), alpha)
			material.set_shader_param("col_mul", col_mul)
		else:
			material.set_shader_param("col_mul", Color.white)
	else:
		material.set_shader_param("col_mul", Color.white)

	efficiency_progress_bar.value = efficiency


func on_restart():
	.on_restart()
	efficiency = 1.0
	material.set_shader_param("col_mul", Color.white)

