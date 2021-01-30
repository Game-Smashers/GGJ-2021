extends KinematicBody2D

signal clicked

const GRAVITY: = 75

var velocity: = Vector2.ZERO
var held: = false

func _ready():
	input_pickable = true
	pass # Replace with function body.

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()
		return

	velocity.y += GRAVITY * delta
	if move_and_collide(velocity):
		velocity = Vector2.ZERO


func pickup():
	if held:
		return
	held = true

func drop():
	if held:
		held = false
