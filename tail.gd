extends Line2D

var _points = []
var last_positon
onready var offset = position
onready var parent = get_parent()

export(int) var max_points = 50
export(float) var distance_factor = 20

func _ready():
	set_as_toplevel(true)
	last_positon = parent.position + offset.rotated(parent.rotation)
	position = Vector2.ZERO
	
	parent.connect("velocity_not_zero", self, "set_process", [true])
	parent.connect("velocity_zero", self, "set_process", [false])

func _process(delta):
	var point = parent.position + offset.rotated(parent.rotation)
	var distance = (point - last_positon).length_squared()
	
	if _points.size() == 0:
		_add_point(point)
	elif point.distance_squared_to(_points.back()) > (parent.velocity.length() * distance * distance_factor):
		_add_point(point)
	else:
		_add_point(point)
	last_positon = point

func _add_point(point: Vector2):
	_points.append(point)
	if _points.size() > max_points:
		_points.remove(0)
	points = _points

func _remove_old_point():
	if _points.size() > 0:
		_points.remove(0)
		points = _points
