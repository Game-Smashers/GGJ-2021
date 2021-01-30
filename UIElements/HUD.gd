tool
extends Control
class_name HUD

export(int) var level: = 1 setget set_level
export(float, 0, 1) var power: = 0.5 setget set_power
export(int) var minutes: = 1 setget set_minutes
export(int) var seconds: = 0 setget set_seconds

onready var power_bar: PowerBar = $HBox/VBoxContainer2/PowerBar
onready var level_label: Label = $HBox/LevelVBox/LevelNumberLabel
onready var timer_label: Label = $HBox/TimerLabel
onready var end_screen: EndScreen = $EndScreen

func end_level(success: bool) -> void:
	end_screen.end_level(success)


func set_power(new_power: float) -> void:
	power_bar.value = new_power
	power = new_power


func set_level(new_level: int) -> void:
	level_label.text = str(new_level)
	level = new_level


func set_minutes(new_minutes: int) -> void:
	timer_label.text = "%02d:%02d" % [new_minutes, seconds]
	minutes = new_minutes


func set_seconds(new_seconds: int) -> void:
	timer_label.text = "%02d:%02d" % [minutes, new_seconds]
	seconds = new_seconds
