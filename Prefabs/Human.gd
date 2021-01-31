class_name Human
extends KinematicBody2D

export(int, 1, 5) var sprite_variant: = 1

onready var collision_shape = $CollisionShape2D
onready var sprite: AnimatedSprite = $Sprite

const GRAVITY: = 75
const DAZE_DURATION: = 2

var velocity: = Vector2.ZERO
var held := false
var hovered := false
var selected := false
var in_room: Room

var grab_offset: Vector2

var sprite_material: Material

func _ready():
	input_pickable = true
	sprite_material = sprite.material.duplicate()
	sprite.set_material(sprite_material)
	sprite.animation = "work%d" % sprite_variant
	sprite.playing = true


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

	if in_room != null:
		in_room.remove_occupant()
		in_room = null


func drop(room):
	if held:
		held = false
	in_room = room
	sprite.animation = "dizzy%d" % sprite_variant
	get_tree().create_timer(DAZE_DURATION).connect("timeout", self, "_on_daze_finished")

	if room != null:
		room.add_occupant()


func _on_daze_finished() -> void:
	sprite.animation = "work%d" % sprite_variant


func on_restart():
	velocity = Vector2.ZERO
	held = false
	hovered = false
	selected = false
	in_room = null

