extends Control

export(Color) var color_lines = Color(0.96, 0.96, 0.96, 0.2)
export(Color) var color_fonts = Color(0.96, 0.96, 0.96, 0.6)
export(int) var nb_points = 128

var points_arc = PoolVector2Array()

var acc_offset_min: float = 0
var acc_offset_max: float = 0
var extra_padding: float = 0

onready var min_label = $MinLabel
onready var max_label = $MaxLabel
onready var acc_label = $AccLabel
onready var velocity_control = $Velocity
onready var velocity_container: Control = $Velocity/VBoxContainer/MarginContainer
onready var velocity_meter: ColorRect = $Velocity/VBoxContainer/MarginContainer/VelocityMeter

onready var half_viewport_size: Vector2

func _ready():
	yield(get_tree(), "idle_frame")
	get_tree().get_root().connect("size_changed", self, "_calc_mouse_offsets")
	_calc_mouse_offsets()
	
func _calc_mouse_offsets():
	half_viewport_size = get_viewport().size / 2
	var half_height = half_viewport_size.y
	acc_offset_min = half_height * Inputs.MOUSE_SCREEN_ACC_FACTOR_MIN
	acc_offset_max = half_height * Inputs.MOUSE_SCREEN_ACC_FACTOR_MAX
	extra_padding = half_height * 0.02
	update()
	
func _draw():
	var inner_circle_points = []
	var outer_circle_points = []

	for i in range(nb_points + 1):
		var angle_point = deg2rad(i * 360 / nb_points)
		inner_circle_points.push_back(half_viewport_size + Vector2(cos(angle_point), sin(angle_point)) * acc_offset_min)
		outer_circle_points.push_back(half_viewport_size + Vector2(cos(angle_point), sin(angle_point)) * acc_offset_max)

	for index_point in range(nb_points):
		draw_line(inner_circle_points[index_point], inner_circle_points[index_point + 1], color_lines)
		draw_line(outer_circle_points[index_point], outer_circle_points[index_point + 1], color_lines)

	min_label.rect_position = half_viewport_size + Vector2.DOWN * (acc_offset_min - min_label.rect_size.y - extra_padding) + Vector2.LEFT * min_label.rect_size / 2
	max_label.rect_position = half_viewport_size + Vector2.DOWN * (acc_offset_max - max_label.rect_size.y - extra_padding) + Vector2.LEFT * max_label.rect_size / 2
	acc_label.rect_position = half_viewport_size + Vector2.DOWN * (acc_offset_max + extra_padding) + Vector2.LEFT * acc_label.rect_size / 2

	velocity_control.rect_size.x = acc_offset_max - acc_offset_min - extra_padding * 4
	velocity_control.rect_position = half_viewport_size + Vector2.LEFT * (acc_offset_max - extra_padding * 2) + Vector2.UP * acc_label.rect_size / 2
	#yield(get_tree(), "idle_frame")
	draw_rect(Rect2(velocity_control.rect_position + velocity_container.rect_position, Vector2(velocity_control.rect_size.x, velocity_container.rect_size.y)), color_lines, false, 2)

func _physics_process(delta):
	velocity_meter.margin_right = -4
	if not weakref(Globals.player):
		velocity_meter.anchor_right = Globals.player.velocity.length() / (Globals.player.velocity_max)
	else:
		velocity_meter.anchor_right = 0
		

	
