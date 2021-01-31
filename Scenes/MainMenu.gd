class_name MainMenu
extends Control

onready var game_scene = preload("res://Scenes/Factory.tscn")

onready var title_screen = $VBoxContainer
onready var level_select_screen = $LevelSelectScreen

var levels: = []

func _ready() -> void:
	levels = load_levels()

	level_select_screen.set_level_count(levels.size())
	level_select_screen.back_button.connect("pressed", self, "_on_back_button_pressed")
	for level_button_idx in range(level_select_screen.level_buttons_root.get_child_count()):
		var level_button = level_select_screen.level_buttons_root.get_child(level_button_idx)
		level_button.connect("pressed", self, "_on_level_button_pressed", [level_button_idx])


func load_levels() -> Array:
	var levels: = []
	var levels_dir_path = "res://Levels/"
	var level_names = []
	var levels_dir = Directory.new()
	levels_dir.open(levels_dir_path)
	levels_dir.list_dir_begin()

	while true:
		var file = levels_dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			level_names.append(levels_dir_path + file)

	levels_dir.list_dir_end()
	for level_name in level_names:
		levels.append(load(level_name))

	return levels


func _start_game(idx: int) -> void:
	var game_scene_instance = game_scene.instance()
	game_scene_instance.levels = levels
	game_scene_instance.current_level_index = idx

	get_tree().root.add_child(game_scene_instance)
	get_tree().current_scene = game_scene_instance
	queue_free()


func _on_StartGameButton_pressed() -> void:
	_start_game(0)


func _on_level_button_pressed(idx: int) -> void:
	_start_game(idx)


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_LevelSelectButton_pressed() -> void:
	title_screen.hide()
	level_select_screen.show()


func _on_back_button_pressed() -> void:
	title_screen.show()
	level_select_screen.hide()
