class_name Projectile
extends Node2D

onready var ship: Ship = get_parent().owner
onready var ship_speed: float = ship.velocity.length()

func _ready():
	set_as_toplevel(true)
