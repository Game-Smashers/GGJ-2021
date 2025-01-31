extends Room

class_name WasteRoom

onready var progress_bar: ProgressBar = $ProgressBar

export(float) var waste_capacity = 10.0

var waste_amount: float = 0.0
var full_timer := 0.0

export(float) var blink_speed = 10.0
export(float) var clean_speed_per_worker = 1.2
export(float) var power_output_impact = 0.85


func _ready():
	on_restart()


func add_waste(amount):
	waste_amount += amount


func _process(delta):
	if game_is_paused:
		return

	if occupants.size() > 0:
		var undazed_occupant_count := get_undazed_occupant_count()
		waste_amount -= undazed_occupant_count * delta * clean_speed_per_worker
		if waste_amount < 0.0:
			waste_amount = 0.0

	progress_bar.value = clamp(waste_amount / waste_capacity, 0.0, 1.0)
	if waste_amount >= (waste_capacity * 0.8):
		full_timer += delta
		var alpha := pow(sin(full_timer * blink_speed) * 0.4 + 0.5, 3.0)
		var col_mul = lerp(Color.white, Color(0.8, 0.1, 0.1, 1.0), alpha)
		material.set_shader_param("col_mul", col_mul)
	else:
		material.set_shader_param("col_mul", Color(1, 1, 1, 1))


func on_restart():
	.on_restart()
	waste_amount = 0.0
	full_timer = 0.0
	material.set_shader_param("col_mul", Color(1, 1, 1, 1))
