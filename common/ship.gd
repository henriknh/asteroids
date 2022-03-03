class_name Ship
extends Entity

var velocity = Vector2.ZERO setget set_velocity
export(int) var velocity_acceleration = 1000
export(int) var velocity_max = 400
export(float) var velocity_drag_coef = 0.03
signal velocity_zero
signal velocity_not_zero

var direction = 0
export(int) var direction_acceleration = 100

var steering = Steering.new(self)

func set_velocity(_velocity: Vector2) -> void:
	if velocity.length() == 0 and _velocity.length() > 0:
		emit_signal("velocity_not_zero")
	if _velocity.length() == 0 and velocity.length() > 0:
		emit_signal("velocity_zero")
	velocity = _velocity
