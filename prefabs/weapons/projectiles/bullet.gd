class_name Bullet
extends Projectile

export(int) var projectile_speed = 1000
export(float) var relative_rotation = 0
var direction: Vector2 = Vector2.ZERO

func _ready():
	position = ship.position
	rotation = ship.rotation + relative_rotation
	direction = get_transform().x.normalized()

func _process(delta):
	position += direction * (ship_speed + projectile_speed) * delta

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body == ship:
		return
	
#	if not body.is_queued_for_deletion():
#		if 'health' in body:
#			body.health -= 20
#		if body == Globals.player:
#			ScreenShake.shake(100)
	
	set_process(false)
	queue_free()
