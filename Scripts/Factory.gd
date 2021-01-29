extends Node2D

var held_object = null

func _ready():
	for node in get_tree().get_nodes_in_group("grabbable"):
		node.connect("clicked", self, "_on_grabbable_clicked")

func _on_grabbable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop() # velocity: Input.get_last_mouse_speed()
			held_object = null
