extends Ship

var squad: Squad
var boid: Boid
var obstacle_handler: ObstacleHandler

func _ready():
	boid = Boid.new(self)
	obstacle_handler = ObstacleHandler.new(self, 16+32, 14)
	
func _physics_process(delta):
	if obstacle_handler.is_obsticle_ahead():
		velocity = lerp(velocity, obstacle_handler.obsticle_avoidance() * velocity.length(), obstacle_handler.collision_factor)
		
		
func _die():
	squad.remove_member(self)
	._die()
