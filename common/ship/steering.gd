extends Node
class_name Steering

var parent: Node

const INPUT_THRESHOLD = 0.01

func _init(_parent: Node):
	parent = _parent

func steer(steer: Vector2, delta: float, acceleration: float = parent.velocity_acceleration, velocity_max: float = parent.velocity_max):
	var velocity = parent.velocity
	if steer.length() > 0:
		velocity += steer * acceleration * delta
	else:
		velocity -= parent.velocity * parent.velocity_drag_coef
	velocity = velocity.clamped(velocity_max)
	
	var direction = parent.get_angle_to(parent.position + velocity)
	
	parent.velocity =  parent.move_and_slide(velocity)#.rotated(parent.rotation))
	parent.rotation += parent.direction_acceleration * direction * delta
