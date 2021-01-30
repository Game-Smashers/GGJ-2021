class_name MainMenu

extends Control

func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_StartGameButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Factory.tscn")
