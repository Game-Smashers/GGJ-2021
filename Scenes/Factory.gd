class_name Factory

extends Node2D

var held_object: Node2D = null
var held_object_start = Vector2(0, 0)

onready var hud = $CanvasLayer/HUD

# Rooms
onready var pump_room = $Rooms/WaterPumpRoom
onready var control_room = $Rooms/ControlRoom
onready var cafeteria = $Rooms/Cafeteria
onready var waste_room = $Rooms/WasteRoom
onready var reactor_room = $Rooms/ReactorRoom
onready var turbine_room = $Rooms/TurbineRoom

onready var power_system = $PowerSystem
onready var timer: Timer = $Timer

var levels = []
var current_level_index := 0

var rooms = []
var hovered_room_index := -1

func _ready():
	for node in get_tree().get_nodes_in_group("grabbable"):
		node.connect("clicked", self, "_on_grabbable_clicked")
	hud.end_screen.replay_level_button.connect("pressed", self, "_on_replay_level_button_pressed")
	hud.end_screen.next_level_button.connect("pressed", self, "_on_next_level_button_pressed")
	hud.end_screen.back_to_menu_button.connect("pressed", self, "_on_back_to_menu_button_pressed")

	# Must match ordering of Types.RoomType
	rooms = [pump_room, turbine_room, reactor_room, waste_room, cafeteria, control_room]

	for room in rooms:
		room.connect("mouse_entered", self, "on_room_mouse_enter", [room.type])
		room.connect("mouse_exited", self, "on_room_mouse_exit")

	load_levels()
	start_level(current_level_index)


func start_level(level_index: int):
	var level: Level = levels[level_index]

	hud.level = level_index
	hud.end_screen.hide()
	timer.start(level.time_limit)


func _process(delta):
	hud.power = (power_system.current_power / power_system.target_power) * 100.0
	hud.minutes = int(timer.time_left / 60)
	hud.seconds = int(timer.time_left) % 60


func _on_grabbable_clicked(object):
	if !held_object:
		held_object = object
		held_object_start = held_object.transform.origin
		held_object.pickup()


func load_levels():
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


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			if hovered_room_index != -1:
				for room in rooms:
					if room.type == rooms[hovered_room_index].type:
						room.selected = true
					else:
						room.selected = false
		else:
			if held_object:
				var human = held_object as Human
				var dropped_over_room = overlapping_room(human)
				held_object.drop() # velocity: Input.get_last_mouse_speed()
				if not dropped_over_room:
					held_object.transform.origin = held_object_start
				held_object = null


func on_room_mouse_enter(roomType):
	hovered_room_index = roomType
	for room in rooms:
		room = room as Room
		if room.type == roomType:
			room.hovered = true
		else:
			room.hovered = false


func on_room_mouse_exit():
	hovered_room_index = -1
	for room in rooms:
		room = room as Room
		room.hovered = false


func overlapping_room(body: KinematicBody2D) -> bool:
	for room in rooms:
		room = room as Room
		if room.overlaps_body(body):
			return true
	return false


func _on_Timer_timeout() -> void:
	hud.end_level(true)


func _on_replay_level_button_pressed() -> void:
	start_level(current_level_index)


func _on_next_level_button_pressed() -> void:
	start_level(current_level_index + 1)


func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
