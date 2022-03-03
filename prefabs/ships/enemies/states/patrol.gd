class_name EnemyPatrol
extends EnemyState

export(int) var patrol_radius = 500
export(int) var patrol_acceleration = 500
export(int) var patrol_velocity_max = 100
var origin: Vector2
var target: Vector2

var target_factor = 5
var separation_factor = 1.2
var separation_distance = 64
var alignment_factor = 0.8
var cohesion_factor = 1

export(bool) var is_debug = false
var target_debug_point: Node2D

func _ready():
	yield(owner, "ready")
	origin = parent.position

func enter(_msg: Dictionary = {}) -> void:
	if parent.squad.leader == parent:
		_calc_new_target()

func physics_process(_delta: float) -> void:
	var steer = Vector2()
	if parent.squad.leader == parent:
		if not target:
			_calc_new_target()
		elif parent.position.distance_to(target) < patrol_radius / 5:
			_calc_new_target()
		steer += (target - parent.position).normalized() * target_factor
	else:
		steer += parent.boid.all()
		
		if parent.position.distance_to(parent.squad.leader.position) < separation_distance * 2:
			steer += (parent.squad.leader.position - parent.position).normalized() * 10

	steer = steer.normalized()
	
	if parent.position.distance_to(origin) > patrol_radius * 1.25:
		parent.steering.steer(steer, _delta)
	else:
		parent.steering.steer(steer, _delta, patrol_acceleration, patrol_velocity_max)

func _calc_new_target():
	var angle = rng.randf() * 360
	target = Vector2(cos(angle), sin(angle)) * patrol_radius + origin
	if is_debug:
		if target_debug_point:
			target_debug_point.queue_free()
		target_debug_point = preload("res://prefabs/debug_point.tscn").instance()
		target_debug_point.position = target
		get_tree().root.add_child(target_debug_point)
