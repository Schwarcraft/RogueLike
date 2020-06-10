extends Node2D


export var cast_radius = 200
export var number_of_points = 40

var new_point
var attackRange
var shape_array : PoolVector2Array
var timer_shape_array : PoolVector2Array
var colors : PoolColorArray
var color = Color(0.99,0.3,0.3,0.5)

var is_base_drawn : bool = false
var is_casting : bool = false

export var duration = 0
export var damage = 10

signal done_casting

var new_vector : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colors = PoolColorArray([color])
	$Timer.start()

func _process(delta):
	if is_casting:
		timer_shape_array = []
		for point in shape_array:
			new_point = point * ( ($Timer.wait_time - $Timer.time_left) /$Timer.wait_time)
			timer_shape_array.append(new_point)
		update()


func _draw() -> void:
#	if is_base_drawn == false:
	z_index=-1
	draw_polygon(shape_array, colors)
	is_base_drawn = true
	draw_polygon(timer_shape_array, colors)

func _on_Timer_timeout() -> void:
	$Timer.stop()
	hide()
	emit_signal("done_casting")
	is_casting = false

