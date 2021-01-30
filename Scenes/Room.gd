tool
extends Area2D

class_name Room

export(Texture) var texture setget set_texture
export(Vector2) var collision_size = Vector2(100, 100) setget set_collision_size
export(Types.RoomType) var type

var hovered: = false
var selected: = false

onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var sprite: Sprite = $Sprite

func _ready():
	material = sprite.material


func _process(delta):
	var darkness = 1.0
	if hovered:
		darkness = 0.8
	if selected:
		darkness *= 0.8
	material.set_shader_param("darkness", darkness)


#func _unhandled_input(event: InputEvent) -> void:
#	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
#		if not event.pressed:
#			selected = hovered


func set_texture(new_texture: Texture) -> void:
	sprite.texture = new_texture
	texture = new_texture


func set_collision_size(new_collision_size: Vector2):
	var shape: = collision_shape.shape as RectangleShape2D
	shape.extents = new_collision_size / 2
	collision_size = new_collision_size
