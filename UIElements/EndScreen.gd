extends Control
class_name EndScreen

const SUCCESS_TITLE: = "Level Passed"
const FAILURE_TITLE: = "Level Failed"

onready var title_label: Label = $TitleLabel
onready var replay_level_button: Button = $ReplayLevelButton
onready var next_level_button: Button = $NextLevelButton
onready var back_to_menu_button: Button = $BackToMenuButton

func end_level(success: bool) -> void:
	if success:
		title_label.text = SUCCESS_TITLE
		next_level_button.disabled = false
	else:
		title_label.text = FAILURE_TITLE
		next_level_button.disabled = true
	visible = true
