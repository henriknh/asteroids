tool
extends KinematicBody2D

const textures = [
	preload("res://assets/sprites/asteroid_16.png"),
	preload("res://assets/sprites/asteroid_32.png"),
	preload("res://assets/sprites/asteroid_64.png"),
	preload("res://assets/sprites/asteroid_128.png"),
	
]

onready var sprite: Sprite = $Sprite
onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready():
	sprite.texture = textures[randi() % textures.size()]
	
	var regex = RegEx.new()
	regex.compile("_(?<digit>[0-9]+)")
	
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = regex.search(sprite.texture.resource_path).get_string("digit") as int / 2
	collision_shape.shape = circle_shape
