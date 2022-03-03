class_name EnemyAttack
extends EnemyState

var target: Node2D = null

export(int) var alert_radius = 500

var case_timer = Timer.new()
export(int) var case_time = 3

func _ready():
	yield(owner, "ready")
	case_timer.wait_time = case_time
	case_timer.one_shot = true
	case_timer.connect("timeout", self, "_stop_casing")
	parent.add_child(case_timer)
	
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = alert_radius
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = circle_shape
	
	var area = Area2D.new()
	area.monitorable = false
	area.collision_mask = 2
	area.connect("body_entered", self, "_start_casing")
	area.connect("body_exited", self, "_start_case_timer", [])
	area.add_child(collision_shape)
	parent.add_child(area)
	
func physics_process(_delta: float) -> void:
	if not target:
		_stop_casing()
	else:
		var steer = (target.position - parent.position).normalized()
		steer += parent.boid.separation()
		steer = steer.normalized()
		parent.steering.steer(steer, _delta)
	
func enter(_msg: Dictionary = {}) -> void:
	target = _msg.target
	_start_case_timer(null)

func exit() -> void:
	target = null

func _start_casing(body):
	if not target:
		if parent.squad:
			for member in parent.squad.members:
				if member.state_machine:
					member.state_machine.transition_to("Attack", {'target': body})
		else:
			_state_machine.transition_to("Attack", {'target': body})
		
func _start_case_timer(body):
	case_timer.start()
	
func _stop_casing():
	if parent.squad:
		if parent.squad.leader == parent:
			for member in parent.squad.members:
				if member.state_machine:
					member.state_machine.transition_to("Patrol")
	else:
		_state_machine.transition_to("Patrol")
