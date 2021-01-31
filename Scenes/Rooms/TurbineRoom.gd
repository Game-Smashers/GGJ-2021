extends Room

class_name TurbineRoom

var efficiency: float = 1.0

func on_restart():
	.on_restart()
	efficiency = 1.0
