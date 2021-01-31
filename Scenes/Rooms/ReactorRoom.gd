extends Room

class_name ReactorRoom

onready var button_up: TextureButton = $ButtonUp
onready var button_down: TextureButton = $ButtonDown

onready var reactor_rods: TextureRect = $Container/ReactorRods

export(float) var rods_down_power_output = 0.4
export(float) var rods_up_power_output = 0.8

export(float) var waste_creation_speed = 0.02

export(Color) var colour_cold
export(Color) var colour_hot

export(float) var rod_move_speed = 1.0
export(float) var rods_down_y = 120.0

var rods_down: bool = false
# 0 = up, 1 = down
var rods_down_percentage: float = 0.0

var temperature: float = 0.5

func _ready():
	on_restart()

func _process(delta):
	var colour
	if temperature > 0.5:
		colour = lerp(Color.white, colour_hot, clamp((temperature - 0.5) * 2.0, 0.0, 1.0))
	else:
		colour = lerp(colour_cold, Color.white, clamp(temperature * 2.0, 0.0, 1.0))
	material.set_shader_param("col_mul", colour)


func _on_ButtonUp_pressed():
	rods_down = false
	button_up.disabled = true
	button_down.disabled = false


func _on_ButtonDown_pressed():
	rods_down = true
	button_up.disabled = false
	button_down.disabled = true


func set_rod_down_percent(rods_down):
	reactor_rods.margin_top = rods_down * rods_down_y

func on_restart():
	.on_restart()
	rods_down = false
	rods_down_percentage = 0.0
	temperature = 0.5

	if rods_down:
		button_up.disabled = false
		button_down.disabled = true
		set_rod_down_percent(1.0)
	else:
		button_up.disabled = true
		button_down.disabled = false
		set_rod_down_percent(0.0)
