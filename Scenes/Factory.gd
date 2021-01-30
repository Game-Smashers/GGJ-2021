class_name Factory

extends Node2D

var held_object: Node2D = null
var held_object_start = Vector2(0, 0)

onready var hud: HUD = $CanvasLayer/HUD

# Rooms
onready var pump_room = $Rooms/WaterPumpRoom
onready var control_room = $Rooms/ControlRoom
onready var cafeteria = $Rooms/Cafeteria
onready var waste_room = $Rooms/WasteRoom
onready var reactor_room = $Rooms/ReactorRoom
onready var turbine_room = $Rooms/TurbineRoom

onready var power_system = $PowerSystem

var game_running := true
var time_left := 0.0

var levels = []
var current_level_index := 0

var rooms = []

func _ready():
	for node in get_tree().get_nodes_in_group("grabbable"):
		node.connect("clicked", self, "_on_grabbable_clicked")

	# TODO: Add water pump room
	rooms = [control_room, cafeteria, waste_room, reactor_room, turbine_room]

	# Get all levels
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

	var current_level = levels[current_level_index]
	time_left = current_level.TimeLimitSeconds as float


func _process(delta):
	hud.power = (power_system.current_power / power_system.target_power) * 100.0

	if game_running:
		time_left -= delta
		if time_left < 0:
			time_left = 0
			game_running = false


func _on_grabbable_clicked(object):
	if !held_object:
		held_object = object
		held_object_start = held_object.transform.origin
		held_object.pickup()


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			var human = held_object as Human
			var dropped_over_room = overlapping_room(human)
			held_object.drop() # velocity: Input.get_last_mouse_speed()
			if not dropped_over_room:
				held_object.transform.origin = held_object_start
			held_object = null


func overlapping_room(body: KinematicBody2D) -> bool:
	for room in rooms:
		room = room as Room
		if room.overlaps_body(body):
			return true
	return false
