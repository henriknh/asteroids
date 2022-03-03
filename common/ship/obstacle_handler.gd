extends Node
class_name ObstacleHandler

var detectors = []#$Detectors.get_children() #2
var sensors = []#$Sensors.get_children() #4

var parent: Node2D
var collision_mask: int = 0
var offset: int = 0
var ray_count: int = 4
var ray_length: int = 100
var spread = 20
var collision_factor: float = 0
var obsticle_avoidance: Vector2 = Vector2()

func _init(_parent: Node, _collision_mask: int, _offset: int = 0, _ray_count = 4, _ray_length = 200, _spread = 45):
	parent = _parent
	collision_mask = _collision_mask
	offset = _offset
	ray_count = _ray_count
	ray_length = _ray_length
	spread = _spread
	init()
	
func init():
	clear()
	var delta = spread / ray_count
	
	create_ray_pair(delta, true)
	for i in int(ceil(ray_count / 2)):
		create_ray_pair((i + 1) * delta, false)

func create_ray_pair(angle: int, is_detector: bool):
	create_ray(angle, is_detector, false)
	create_ray(angle, is_detector, true)
	
func create_ray(angle: int, is_detector: bool, is_inverted: bool):
	var cast_to = Vector2(ray_length, 0)
	var inverted = 1 if is_inverted else -1

	var raycast = RayCast2D.new()
	if is_detector:
		raycast.position = Vector2(0, offset * inverted)
		raycast.cast_to = cast_to#.rotated(deg2rad(angle * -inverted)) * 0.8
	else:
		raycast.cast_to = cast_to.rotated(deg2rad(angle * inverted))
	raycast.enabled = true
	raycast.collision_mask = collision_mask
	
	if is_detector:
		detectors.append(raycast)
	else:
		sensors.append(raycast)
		
	parent.add_child(raycast)

func clear():
	for detector in detectors:
		detector.queue_free()
	for sensor in sensors:
		sensor.queue_free()
	
	detectors = []
	sensors = []

func add_exception(exception: Object) -> void:
	for ray in detectors:
		ray.add_exception(exception)

func add_exceptions(exceptions: Array) -> void:
	for ray in detectors:
		for exception in exceptions:
			ray.add_exception(exception)

func remove_exception(exception: Object) -> void:
	for ray in detectors:
		ray.remove_exception(exception)

func is_obsticle_ahead() -> bool:
	collision_factor = 0
	for ray in detectors:
		if ray.is_colliding():
			collision_factor = parent.global_position.distance_to(ray.get_collision_point()) / ray_length
			return true
	return false

func obsticle_avoidance() -> Vector2:
	obsticle_avoidance = Vector2()
	for ray in sensors:
		if not ray.is_colliding():
			obsticle_avoidance = ray.cast_to.rotated(ray.rotation + parent.rotation).normalized()
			break
	return obsticle_avoidance
