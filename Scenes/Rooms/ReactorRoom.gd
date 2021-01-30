extends Room

class_name ReactorRoom

export(float) var rods_down_power_output = 20.0
export(float) var rods_up_power_output = 100.0

var rods_down: bool = false
# 0 = up, 1 = down
var rods_down_percentage: float = 0.0

var rod_move_speed := 1.0
