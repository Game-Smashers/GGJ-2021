class_name Factory

extends Node2D

var held_object: Node2D = null
var held_object_start = Vector2(0, 0)

onready var hud: HUD = $CanvasLayer/HUD

# Rooms
onready var pump_room: WaterPumpRoom = $Rooms/WaterPumpRoom
onready var turbine_room: TurbineRoom = $Rooms/TurbineRoom
onready var reactor_room: ReactorRoom = $Rooms/ReactorRoom
onready var waste_room: WasteRoom = $Rooms/WasteRoom
onready var cafeteria: Cafeteria = $Rooms/Cafeteria

onready var timer: Timer = $Timer
onready var sound_player = $Audio

onready var fullscreen_tex: TextureRect = $CanvasLayer/TextureRect

onready var button_sound = preload("res://Audio/SFX/ButtonPress.wav")
const temperature_curve: Curve = preload("res://Curves/temperature_curve.tres")

var levels = []
var current_level_index := 0

var humans = []
var rooms = []

var selected_human: Human = null
var selected_room: Room = null
var hovered_room_index := -1
var hovered_human: Human = null
var human_starting_positions = []

var in_red := false
var seconds_in_red := 0.0
var max_seconds_in_red := 5.0


func _ready():
	hud.end_screen.replay_level_button.connect("pressed", self, "_on_replay_level_button_pressed")
	hud.end_screen.next_level_button.connect("pressed", self, "_on_next_level_button_pressed")
	hud.end_screen.back_to_menu_button.connect("pressed", self, "_on_back_to_menu_button_pressed")

	# Must match ordering of Types.RoomType
	rooms = [pump_room, turbine_room, reactor_room, waste_room, cafeteria]

	for room in rooms:
		room.connect("mouse_entered", self, "on_room_mouse_enter", [room.type])
		room.connect("mouse_exited", self, "on_room_mouse_exit", [room.type])

	for human in $Humans.get_children():
		humans.append(human)
		human.connect("mouse_entered", self, "on_human_mouse_enter", [human])
		human.connect("mouse_exited", self, "on_human_mouse_exit", [human])
		human_starting_positions.append(human.transform.origin)
		human.in_room = cafeteria
		cafeteria.add_occupant(human)

	start_level(current_level_index)


func start_level(level_index: int):
	var level: Level = levels[level_index]

	hud.level = level_index
	hud.end_screen.hide()
	timer.start(level.time_limit)

	for i in range(humans.size()):
		humans[i].transform.origin = human_starting_positions[i]
		humans[i].on_restart()

	selected_human = null
	selected_room = null
	hovered_room_index = -1
	hovered_human = null

	for i in range(rooms.size()):
		rooms[i].on_restart()

	in_red = false
	seconds_in_red = 0.0
	fullscreen_tex.material.set_shader_param("col_mul", Color.transparent)


func _process(delta):
	if in_red:
		fullscreen_tex.material.set_shader_param("col_mul", Color(0.9, 0.1, 0.1, clamp(seconds_in_red / max_seconds_in_red * 0.6, 0.0, 1.0))) #pow(sin(full_screen_red_flash * full_screen_flash_speed) * 0.5 + 0.5, 3.0)))
	else:
		fullscreen_tex.material.set_shader_param("col_mul", Color.transparent)

	# Calculate power output
	if reactor_room.rods_down:
		if reactor_room.rods_down_percentage != 1.0:
			reactor_room.rods_down_percentage += delta * reactor_room.rod_move_speed
			if reactor_room.rods_down_percentage > 1.0:
				reactor_room.rods_down_percentage = 1.0
	else:
		if reactor_room.rods_down_percentage != 0.0:
			reactor_room.rods_down_percentage -= delta * reactor_room.rod_move_speed
			if reactor_room.rods_down_percentage < 0.0:
				reactor_room.rods_down_percentage = 0.0

	reactor_room.set_rod_down_percent(reactor_room.rods_down_percentage)

	var power_output = lerp(reactor_room.rods_up_power_output, reactor_room.rods_down_power_output, reactor_room.rods_down_percentage)
	power_output *= turbine_room.efficiency
	# More waste slows down production speed
	power_output *= 1.0 - clamp(waste_room.waste_amount / waste_room.waste_capacity, 0.0, 0.99)
	#print(power_output)
	hud.power = power_output
	hud.minutes = int(timer.time_left / 60)
	hud.seconds = int(timer.time_left) % 60

	in_red = (power_output <= 0.1 or power_output >= 0.9)
	if in_red:
		seconds_in_red += delta
		if seconds_in_red >= max_seconds_in_red:
			hud.end_screen.end_level(false, 0, 0)
			timer.stop()
	else:
		seconds_in_red = 0.0

	reactor_room.temperature = temperature_curve.interpolate(power_output)

	var added_waste = power_output * reactor_room.waste_creation_speed
	waste_room.add_waste(added_waste)


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			# Check for human selections
			if hovered_human != null:
				for human in humans:
					human.selected = human == hovered_human
				selected_human = hovered_human
				held_object = hovered_human
				held_object_start = hovered_human.transform.origin
				var grab_offset = hovered_human.transform.origin - get_global_mouse_position()
				hovered_human.pickup(grab_offset)
				sound_player.play_pickup_sound()
			else:
				hovered_human = null

			get_tree().set_input_as_handled()

			if hovered_human == null and hovered_room_index != -1:
				for room in rooms:
					if room.type == rooms[hovered_room_index].type:
						room.selected = true
						selected_room = room
					else:
						room.selected = false
		else: # Mouse released
			if held_object:
				# Check for dropped humans in rooms
				var human = held_object as Human
				var room = overlapping_room(human)
				held_object.drop(room)
				human.in_room = room
				if room == null:
					# If droped outside a room return to previous pos
					held_object.transform.origin = held_object_start
				held_object = null
				get_tree().set_input_as_handled()
				sound_player.play_drop_sound()
			else:
				for human in humans:
					human.selected = false
				if hovered_room_index == -1:
					for room in rooms:
						room.selected = false


func on_room_mouse_enter(room_type):
	hovered_room_index = room_type
	for room in rooms:
		room.hovered = room.type == room_type


func on_room_mouse_exit(room_type):
	rooms[room_type].hovered = false
	if hovered_room_index == room_type:
		hovered_room_index = -1


func on_human_mouse_enter(human):
	hovered_human = human
	human.hovered = true


func on_human_mouse_exit(human):
	human.hovered = false
	if hovered_human == human:
		hovered_human = null


func overlapping_room(body: KinematicBody2D) -> Room:
	for room in rooms:
		room = room as Room
		var rect: RectangleShape2D = room.collision_shape.shape
		var p1 = body.transform.origin.x > (room.transform.origin.x - rect.extents.x) and body.transform.origin.x < (room.transform.origin.x + rect.extents.x)
		var p2 = body.transform.origin.y > (room.transform.origin.y - rect.extents.y) and body.transform.origin.y < (room.transform.origin.y + rect.extents.y)
		if p1 and p2:
			return room
	return null


func _on_Timer_timeout() -> void:
	hud.end_screen.end_level(true, 1, 2)


func _on_replay_level_button_pressed() -> void:
	play_sound(button_sound)
	start_level(current_level_index)


func _on_next_level_button_pressed() -> void:
	play_sound(button_sound)
	start_level(current_level_index + 1)


func _on_back_to_menu_button_pressed() -> void:
	play_sound(button_sound)
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func play_sound_from_file(audio_file):
	if File.new().file_exists(audio_file):
		var audio_stream = load(audio_file)
		play_sound(audio_stream)

func play_sound(audio_stream):
	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = audio_stream
	player.play()
	yield(player, "finished")
	remove_child(player)
	player.queue_free()
