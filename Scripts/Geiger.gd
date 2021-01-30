extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_Geiger_finished()


func _on_Geiger_finished():
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout") 
	add_child(timer)
	var start_time = rand_range(5.0, 20.0)
	timer.start(start_time)


func _on_timer_timeout():
	timer.stop()
	play()
