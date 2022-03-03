extends Label

func _physics_process(delta):
	text = "%d" % Engine.get_frames_per_second()
