class_name Boid
extends Node

var parent: Entity

var target_factor = 5
var separation_factor = 1.2
var separation_distance = 64
var alignment_factor = 0.8
var cohesion_factor = 1

func _init(_parent):
	parent = _parent
	
func all() -> Vector2:
	return separation() + alignment() + cohesion()

func separation() -> Vector2:
	if parent.squad.leader == parent:
		return Vector2.ZERO
	
	var count = 0
	var steer = Vector2.ZERO
	for member in parent.squad.members:
		var distance = member.position.distance_to(parent.position)
		if distance > 0 and distance < separation_distance:
			steer += (parent.position - member.position).normalized() / distance
			count += 1
	
	if count > 0:
		steer /= count
		
	if steer.length() > 0:
		steer = steer.normalized();
		steer *= parent.velocity_max
		steer -= parent.velocity
		steer *= 0.1
	
	return steer * separation_factor
	
func alignment() -> Vector2:
	var count = 0
	var steer = Vector2.ZERO
	if parent.squad.members.size() > 1:
		for member in parent.squad.members:
			steer += member.velocity
			count += 1
		
	if count > 0:
		steer /= count
	if steer.length() > 0:
		steer = steer.normalized();
		steer *= parent.velocity_max
		steer -= parent.velocity
		steer *= 0.1
	
	return steer * alignment_factor
	
func cohesion() -> Vector2:
	if parent.squad.leader == parent:
		return Vector2.ZERO
	else:
		if parent.squad.leader:
			return (parent.squad.leader.position - parent.position).normalized()
			return seek(parent.squad.leader.position)
		else:
			return Vector2.ZERO
			var count = 0
			var steer = Vector2.ZERO
			for member in parent.squad.members:
				var distance = member.position.distance_to(parent.position)
				if distance > 0 and distance > separation_distance:
					steer += member.position
					count += 1
				
			if count > 0:
				steer /= count
			
			return seek(steer) * cohesion_factor

func seek(steer: Vector2):
	var desired = steer - parent.position
	desired = desired.normalized();
	desired *= parent.velocity_max

	# Steering = Desired minus Velocity
	steer = desired - parent.velocity
	steer = steer.normalized();
	steer *= 0.1
	return steer;
