tool
extends Area2D

export(Texture) var texture setget set_texture
export(Vector2) var collision_size = Vector2(100, 100) setget set_collision_size

var hovered: = false
var selected: = false

onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var sprite: Sprite = $Sprite

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if not event.pressed:
			selected = hovered
			print("Selected: ", selected)


func set_texture(new_texture: Texture) -> void:
	sprite.texture = new_texture
	texture = new_texture


func set_collision_size(new_collision_size: Vector2):
	var shape: = collision_shape.shape as RectangleShape2D
	shape.extents = new_collision_size / 2
	collision_size = new_collision_size


func _on_Room_mouse_entered() -> void:
	hovered = true


func _on_Room_mouse_exited() -> void:
	hovered = false
