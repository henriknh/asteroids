class_name Entity
extends KinematicBody2D

onready var state_machine := get_node_or_null("StateMachine")

export(int) var health = 10 setget _set_health

func _set_health(_health):
	health = _health
	if health < 0:
		_die()

func _die():
	queue_free()
