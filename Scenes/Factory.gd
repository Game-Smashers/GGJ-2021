extends Node2D

var held_object = null

onready var progress_bar = $ProgressBar

# Rooms
onready var control_room = $Rooms/ControlRoom
onready var cafeteria = $Rooms/Cafeteria
onready var waste_room = $Rooms/WasteRoom
onready var reactor_room = $Rooms/ReactorRoom
onready var turbine_room = $Rooms/TurbineRoom

onready var power_system = $PowerSystem

var rooms = []

func _ready():
	for node in get_tree().get_nodes_in_group("grabbable"):
		node.connect("clicked", self, "_on_grabbable_clicked")

func _process(delta):
	progress_bar.value = (power_system.current_power / power_system.target_power) * 100.0

func _on_grabbable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop() # velocity: Input.get_last_mouse_speed()
			held_object = null
