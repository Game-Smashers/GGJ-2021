extends Room

class_name ReactorRoom

onready var button_up: TextureButton = $ButtonUp
onready var button_down: TextureButton = $ButtonDown

onready var reactor_rods: TextureRect = $Container/ReactorRods

export(float) var rods_down_power_output = 20.0
export(float) var rods_up_power_output = 100.0

export(float) var waste_creation_speed = 0.02

var rods_down: bool = false
# 0 = up, 1 = down
var rods_down_percentage: float = 0.0

var rod_move_speed := 1.0
var rods_down_y = 120

func _ready():
	if rods_down:
		button_up.disabled = false
		button_down.disabled = true
		set_rod_down_percent(1.0)
	else:
		button_up.disabled = true
		button_down.disabled = false


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
