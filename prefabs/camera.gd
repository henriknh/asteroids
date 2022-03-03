extends Camera2D

export(float) var offset_factor = 0.4
export(int) var offset_speed = 10
var offset_target = Vector2()
export(float) var zoom_factor = 2
export(float) var zoom_out_speed = 3
export(float) var zoom_in_speed = 2
var zoom_speed = 0
var zoom_target = zoom[0]
var prev_velocity = Vector2()
onready var initial_zoom = zoom[0]

func _ready():
	Globals.camera = self

func _process(delta):
	position = Globals.player.position
	offset = lerp(offset, offset_target, offset_speed * delta)
	zoom = lerp(zoom[0], zoom_target * zoom_factor + initial_zoom, delta * zoom_speed) * Vector2.ONE

func _physics_process(delta):
	var speed_ratio = Globals.player.velocity.length() / (Globals.player.velocity_max)
	offset_target = Globals.player.velocity.normalized() * speed_ratio * get_viewport_rect().size * offset_factor
	
	zoom_target = speed_ratio
	zoom_speed = zoom_out_speed if Globals.player.velocity.length() > prev_velocity.length() else zoom_in_speed
	prev_velocity = Globals.player.velocity

