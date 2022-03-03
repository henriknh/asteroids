extends Node2D

var rng = RandomNumberGenerator.new()

var c = 0
func _ready():
	rng.randomize()
	_spawn()
	
func _spawn():
	
	if c > 1:
		return
	c += 1
	
	yield(get_tree().create_timer(2), "timeout")
	
	var squad_members = [preload("res://prefabs/ships/enemies/leader.tscn").instance()]
	
	for _i in range(rng.randi_range(2,4)):
		squad_members.append(preload("res://prefabs/ships/enemies/medium.tscn").instance())
		
	var squad = Squad.new(squad_members, squad_members[0])
	
	for member in squad.members:
		get_parent().add_child(member)

	_spawn()
