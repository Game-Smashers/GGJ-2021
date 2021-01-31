extends VBoxContainer


onready var back_button: Button = $BackButton
onready var level_buttons_root: Control = $HBoxContainer

onready var level_button_scene: PackedScene = preload("res://UIElements/LevelButton.tscn")

# Called when the node enters the scene tree for the first time.
func set_level_count(count: int) -> void:
	for level_idx in range(count):
		var level_button: Button = level_button_scene.instance()
		level_button.text = str(level_idx + 1)
		level_buttons_root.add_child(level_button)
