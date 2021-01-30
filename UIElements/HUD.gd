tool
extends Control

export(int) var level: = 1 setget set_level
export(int) var minutes: = 1 setget set_minutes
export(int) var seconds: = 0 setget set_seconds

onready var level_label: Label = $HBox/LevelVBox/LevelNumberLabel
onready var timer_label: Label = $HBox/TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_level(new_level: int) -> void:
	level_label.text = str(new_level)
	level = new_level


func set_minutes(new_minutes: int) -> void:
	timer_label.text = "%02d:%02d" % [new_minutes, seconds]
	minutes = new_minutes


func set_seconds(new_seconds: int) -> void:
	timer_label.text = "%02d:%02d" % [minutes, new_seconds]
	seconds = new_seconds
