extends KinematicBody2D
class_name Human

export(int, 1, 5) var sprite_variant: = 1

onready var collision_shape = $CollisionShape2D
onready var sprite: AnimatedSprite = $Sprite
onready var dazed_audio = $DazedSound
onready var timer: Timer = $Timer

const GRAVITY: = 75
const DAZE_DURATION: = 2

var velocity: = Vector2.ZERO
var held := false
var hovered := false
var selected := false
var in_room: Room
var energy_level := 0.0
var room_skilled_in
var room_unskilled_in

var names_list = ["Alex", "Taylor", "Addison", "Jordan", "Parker", "Logan", "Drew", "Adrian", "Flynn", "Quinn"]
var human_name: String
var grab_offset: Vector2
var sprite_material: Material
var last_room: Room
var dazed := false

func _ready():
	input_pickable = true
	sprite_material = sprite.material.duplicate()
	sprite.set_material(sprite_material)
	sprite.animation = "work%d" % sprite_variant
	sprite.playing = true

	randomize()

	human_name = names_list[randi() % names_list.size()]

	room_skilled_in = Types.human_traits[sprite_variant - 1][0]
	room_unskilled_in = Types.human_traits[sprite_variant - 1][1]

	timer.connect("timeout", self, "_on_daze_finished")


func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position() + grab_offset
		if grab_offset.x > 0:
			global_transform.x = Vector2(3.6, 0.4)
			global_transform.y = Vector2(-0.4, 3.6)
		else:
			global_transform.x = Vector2(-3.6, 0.4)
			global_transform.y = Vector2(0.4, 3.6)
		return

	global_transform.x = Vector2(4.0, 0.0)
	global_transform.y = Vector2(0.0, 4.0)

	velocity.y += GRAVITY * delta
	if move_and_collide(velocity):
		velocity = Vector2.ZERO


func _process(delta):
	var darkness = 1.0
	if selected:
		darkness = 0.6
	elif hovered:
		darkness = 0.8
	sprite_material.set_shader_param("darkness", darkness)


func pickup(grab_offset):
	if held:
		return
	held = true
	self.grab_offset = grab_offset
	sprite.animation = "hang%d" % sprite_variant

	last_room = in_room

	if in_room != null:
		in_room.remove_occupant(self)
		in_room = null


func drop(room):
	if held:
		held = false
	var same_room = (last_room == room)
	in_room = room
	if same_room and not dazed:
		sprite.animation = "work%d" % sprite_variant
	else:
		sprite.animation = "dizzy%d" % sprite_variant
		if not same_room:
			dazed_audio.play()
			timer.start(DAZE_DURATION)
			dazed = true
	if room != null:
		room.add_occupant(self)


func _on_daze_finished() -> void:
	dazed = false
	dazed_audio.stop()
	sprite.animation = "work%d" % sprite_variant


func on_restart(starting_room):
	velocity = Vector2.ZERO
	held = false
	hovered = false
	selected = false
	in_room = starting_room
	last_room = starting_room

