extends RigidBody2D

signal clicked

var held = false

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

func pickup():
	if held:
		return
	mode = RigidBody2D.MODE_STATIC
	held = true

func drop():
	if held:
		mode = RigidBody2D.MODE_RIGID
		held = false
