tool
extends Control
class_name HUD

export(int) var level: = 1 setget set_level
export(float, 0, 1) var power: = 0.5 setget set_power
export(int) var minutes: = 1 setget set_minutes
export(int) var seconds: = 0 setget set_seconds

onready var power_bar: PowerBar = $HBox/VBoxContainer2/PowerBar
onready var level_label: Label = $HBox/LevelVBox/LevelNumberLabel
onready var timer_label: Label = $VBoxContainer3/TimerLabel
onready var end_screen: EndScreen = $EndScreen
onready var alarm_panel: Panel = $AlarmPanel
onready var alarm_animation_player: AnimationPlayer = $AlarmAnimationPlayer

var flashing_red := false
var solid_red := false
var accum_time := 0.0
var flash_speed = 12.0

func set_power(new_power: float) -> void:
	power_bar.value = new_power
	power = new_power


func set_level(new_level: int) -> void:
	level_label.text = str(new_level + 1)
	level = new_level


func set_minutes(new_minutes: int) -> void:
	timer_label.text = "%02d:%02d" % [new_minutes, seconds]
	minutes = new_minutes

	flashing_red = (minutes == 0 and seconds < 10)
	solid_red = (minutes == 0 and seconds == 0)


func set_seconds(new_seconds: int) -> void:
	timer_label.text = "%02d:%02d" % [minutes, new_seconds]
	seconds = new_seconds

	flashing_red = (minutes == 0 and seconds < 10)
	solid_red = (minutes == 0 and seconds == 0)


func _process(delta):
	if solid_red:
		timer_label.add_color_override("font_color", Color.red)
	elif flashing_red:
		accum_time += delta
		var alpha = pow(sin(accum_time * flash_speed) * 0.4 + 0.5, 3.0)
		timer_label.add_color_override("font_color", lerp(Color.white, Color.red, alpha))
	else:
		timer_label.add_color_override("font_color", Color.white)


func start_alarm():
	alarm_panel.show()
	alarm_animation_player.play("alarmFlash")


func stop_alarm():
	alarm_panel.hide()
	alarm_animation_player.stop()
