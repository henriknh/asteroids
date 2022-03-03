extends Node2D


onready var shake_timer = Timer.new()
onready var tween = Tween.new()
onready var default_offset = Vector2()

var shake_amount = 0


func _ready():
	shake_timer.connect("timeout", self, "_on_shake_timeout")
	add_child(shake_timer)
	add_child(tween)
	set_process(false)


func _process(delta):
	Globals.camera.offset = Vector2(rand_range(-shake_amount, shake_amount), rand_range(-shake_amount, shake_amount)) * delta + default_offset
	Globals.ui_hud.offset = Vector2(rand_range(-shake_amount, shake_amount), rand_range(-shake_amount, shake_amount)) * delta + default_offset


func shake(new_shake, shake_time=0.4, shake_limit=100):
	shake_amount += new_shake
	if shake_amount > shake_limit:
		shake_amount = shake_limit
	
	
	tween.stop_all()
	set_process(true)
	
	if shake_timer.time_left < shake_time:
		var additional_time = shake_time - shake_timer.time_left
		shake_timer.wait_time = additional_time
		shake_timer.start()


func _on_shake_timeout():
	shake_amount = 0
	set_process(false)
	Globals.camera.offset = default_offset#Vector2(rand_range(-shake_amount, shake_amount), rand_range(-shake_amount, shake_amount)) * delta + default_offset
	Globals.ui_hud.offset = default_offset#Vector2(rand_range(-shake_amount, shake_amount), rand_range(-shake_amount, shake_amount)) * delta + default_offset

	
	#tween.interpolate_property(Globals.camera, "offset", Globals.camera.offset, default_offset, 0.0, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	#tween.start()
