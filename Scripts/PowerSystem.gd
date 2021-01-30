extends Node

var current_power = 0.0
var power_start = 0.0
var target_power = 100.0
var time_left = 100.0
var start_time = 100.0


func _process(delta):
	if time_left <= 0.0:
		print("done")
	else:
		time_left -= delta
		gather_power(delta)
		print("power: ", current_power)

func gather_power(delta):
	#gather the power from each room boi
	#for the moment just let it go up by a small amount over time
	current_power += delta
