extends Node2D

enum GunModeEnum { NORMAL, BURST, SPREAD }

# General values
export(PackedScene) var projectile_scene = preload("res://prefabs/weapons/projectiles/bullet.tscn")
export(GunModeEnum) var gun_mode = GunModeEnum.NORMAL
export(float) var rotation_deviation = 0.02
export(bool)  var trigger_automatric = false
export(int)   var trigger_range = 1000
export(int)   var trigger_spread = 30
export(float) var normal_mode_cooldown_time = 0.05
export(float) var burst_mode_cooldown_time = 0.6
export(int)   var burst_mode_bullet_count = 3
export(float) var burst_mode_interval = 0.06
export(float) var burst_mode_interval_deviation = 0.02
export(float) var spread_mode_cooldown_time = 0.6
export(int)   var spread_mode_bullet_count = 5
export(float) var spread_mode_deviation = 0.05

var trigger_active: bool = false

onready var cooldown: Timer = $Cooldown
onready var area: Area2D = $Area2D
onready var collision_polygon: CollisionPolygon2D = $Area2D/CollisionPolygon2D

func _ready():
	if not projectile_scene:
		breakpoint
	
	spread_mode_bullet_count = int(stepify(spread_mode_bullet_count, 2))
	
	collision_polygon.polygon = [
		Vector2(),
		Vector2(trigger_range, 0).rotated(deg2rad(trigger_spread / 2)),
		Vector2(trigger_range, 0).rotated(deg2rad(-trigger_spread / 2))
	]
	area.visible = trigger_automatric
	

func _process(event):
	if not cooldown or not cooldown.is_stopped():
		return
	
	if Input.is_action_pressed("ui_fire") or trigger_active:
		
		match(gun_mode):
			GunModeEnum.NORMAL:
				_fire()
				cooldown.start(normal_mode_cooldown_time)
			GunModeEnum.BURST:
				for i in range(burst_mode_bullet_count):
					_fire()
					yield(get_tree().create_timer(burst_mode_interval + calc_deviation(burst_mode_interval_deviation)), "timeout")
				cooldown.start(burst_mode_cooldown_time)
			GunModeEnum.SPREAD:
				_fire()
				for i in range(spread_mode_bullet_count / 2):
					_fire(-spread_mode_deviation * (i + 1))
					_fire(spread_mode_deviation * (i + 1))
				cooldown.start(spread_mode_cooldown_time)

func _fire(relative_rotation: float = 0):
	var projectile = projectile_scene.instance()
	projectile.relative_rotation = relative_rotation + calc_deviation(rotation_deviation)
	add_child(projectile)

func calc_deviation(deviation: float) -> float:
	return rand_range(-deviation / 2, deviation / 2)


func _on_body_entered(body):
	if body == Globals.player:
		trigger_active = true

func _on_body_exited(body):
	if body == Globals.player:
		trigger_active = false
