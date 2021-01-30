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

onready var game_over_text: RichTextLabel = $GameOverText
onready var you_won_text: RichTextLabel = $YouWonText
onready var casualties_text: RichTextLabel = $CasulatiesText


func set_game_over(game_over: bool, seconds_remaining: float, casualties: int) -> void:
	if game_over:
		game_over_text.visible = true
		you_won_text.visible = true
		casualties_text.visible = true
	else:
		game_over_text.visible = false
		you_won_text.visible = false
		casualties_text.visible = false
		you_won_text.text = "You won with " + String(seconds_remaining) + " seconds to spare"
		casualties_text.text = "There were " + String(casualties) + " casualties"


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
