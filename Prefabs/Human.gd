class_name Human

extends KinematicBody2D

onready var collision_shape = $CollisionShape2D

const GRAVITY: = 75

var velocity: = Vector2.ZERO
var held := false
var hovered := false
var selected := false
var in_room: Room

var grab_offset: Vector2

var sprite_material

func _ready():
	input_pickable = true
	sprite_material = $Sprite.material.duplicate()
	$Sprite.set_material(sprite_material)


func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position() + grab_offset
		if grab_offset.x > 0:
			global_transform.x = Vector2(0.9,0.1).normalized()
			global_transform.y = Vector2(-0.1,0.9).normalized()
		else:
			global_transform.x = Vector2(-0.9,0.1).normalized()
			global_transform.y = Vector2(0.1,0.9).normalized()
		return

	global_transform.x = Vector2(1.0, 0.0)
	global_transform.y = Vector2(0.0, 1.0)

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

	if in_room != null:
		in_room.remove_occupant()
		in_room = null


func drop(room):
	if held:
		held = false
	in_room = room

	if room != null:
		room.add_occupant()
