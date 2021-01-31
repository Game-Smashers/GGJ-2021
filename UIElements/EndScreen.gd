extends Control
class_name EndScreen

const SUCCESS_TITLE: = "Level Passed"
const FAILURE_TITLE: = "Level Failed"
const CASUALTIES_FORMAT: = "Casualties: %d"

const SUCCESS_RATING_MODULATE: = Color.white
const FAILURE_RATING_MODULATE: = Color(1, 1, 1, 0.2)

onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
onready var casualties_label: Label = $Panel/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/CasualtiesLabel
onready var replay_level_button: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/ReplayLevelButton
onready var next_level_button: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/NextLevelButton
onready var back_to_menu_button: Button = $Panel/MarginContainer/VBoxContainer/HBoxContainer/BackToMenuButton
onready var rating_barrel1: Control = $Panel/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/RatingBarrel
onready var rating_barrel2: Control = $Panel/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/RatingBarrel2
onready var rating_barrel3: Control = $Panel/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/RatingBarrel3

func end_level(success: bool, casualties: int, rating: int) -> void:
	if success:
		title_label.text = SUCCESS_TITLE
		next_level_button.disabled = false
	else:
		title_label.text = FAILURE_TITLE
		next_level_button.disabled = true
	casualties_label.text = CASUALTIES_FORMAT % casualties
	_set_rating(rating)

	visible = true

func _set_rating(rating: int):
	rating_barrel1.modulate = FAILURE_RATING_MODULATE
	rating_barrel2.modulate = FAILURE_RATING_MODULATE
	rating_barrel3.modulate = FAILURE_RATING_MODULATE

	if rating > 0:
		rating_barrel1.modulate = SUCCESS_RATING_MODULATE
	if rating > 1:
		rating_barrel2.modulate = SUCCESS_RATING_MODULATE
	if rating > 2:
		rating_barrel3.modulate = SUCCESS_RATING_MODULATE
