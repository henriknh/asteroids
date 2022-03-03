extends Node

var camera: Camera2D
var player: Ship
var ui_static: CanvasLayer
var ui_hud: CanvasLayer

func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	for prop in get_property_list():
		if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE and not get(prop.name):
			printerr(prop)
			breakpoint
