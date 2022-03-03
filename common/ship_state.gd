class_name ShipState
extends State

var parent: Ship

func _ready() -> void:
	yield(owner, "ready")
	parent = owner
