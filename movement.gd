extends Node

const INPUT_THRESHOLD = 0.01
onready var parent = get_parent()


var acc_offset_min: float = 0
var acc_offset_max: float = 0

func _ready():
	_calc_mouse_offsets()
	get_tree().get_root().connect("size_changed", self, "_calc_mouse_offsets")
	
func _calc_mouse_offsets():
	var half_height = get_viewport().size.y / 2
	acc_offset_min = half_height * Inputs.MOUSE_SCREEN_ACC_FACTOR_MIN
	acc_offset_max = half_height * Inputs.MOUSE_SCREEN_ACC_FACTOR_MAX

func _physics_process(delta):
	var acc: Vector2 = (parent.get_global_mouse_position() - parent.position).normalized()
	var dist = parent.get_global_mouse_position().distance_to(parent.position)
	var acc_force = (dist - acc_offset_min) / (acc_offset_max - acc_offset_min)
	acc_force = clamp(acc_force, 0, 1)
	parent.steering.steer(acc * acc_force, delta)
