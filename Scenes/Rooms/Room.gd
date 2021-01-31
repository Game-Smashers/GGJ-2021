tool
extends Area2D

class_name Room

export(Types.RoomType) var type

var occupant_count: int
var hovered: = false
var selected: = false

var room_name: String

onready var collision_shape: CollisionShape2D = $CollisionShape2D
onready var sprite: Sprite = $Sprite

func _ready():
	material = sprite.material
	room_name = str(Types.RoomType.keys()[type]).to_lower()
	room_name[0] = room_name[0].to_upper()
	room_name = room_name.replace('_', ' ')


func _process(delta):
	var darkness = 1.0
	if selected:
		darkness = 0.6
	elif hovered:
		darkness = 0.8
	material.set_shader_param("darkness", darkness)


func add_occupant():
	occupant_count += 1


func remove_occupant():
	occupant_count -= 1


func on_restart():
	hovered = false
	selected = false
	occupant_count = 0
