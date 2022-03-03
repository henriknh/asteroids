class_name Squad

var members: Array = []
var leader: Ship setget _set_leader

func _init(_members: Array, _leader: Ship):
	self.members = _members
	self.leader = _leader
	
	for member in members:
		member.squad = self

func _set_leader(_leader: Ship) -> void:
	leader = _leader
	leader.modulate = Color(1, 0.8, 0.5)

func remove_member(ship: Ship):
	members.erase(ship)
	if leader == ship:
		if members.size() > 0:
			self.leader = members[0]
			var partrol_state = ship.get_node_or_null("StateMachine/Patrol")
			if partrol_state and partrol_state.target:
				leader.get_node("StateMachine/Patrol").target = partrol_state.target
		else:
			leader = null
