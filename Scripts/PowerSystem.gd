class_name PowerSystem

extends Node

var current_power = 0.0
var power_start = 0.0
var target_power = 100.0

var factory: Factory

func _ready():
	factory = get_parent()

func _process(delta):
	if factory.game_running:
		gather_power(delta)
		#print("power: ", current_power)

func gather_power(delta):
	#gather the power from each room boi
	#for the moment just let it go up by a small amount over time
	current_power += delta
