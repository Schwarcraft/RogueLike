extends KinematicBody2D

export var cast_radius = 200
export var number_of_points = 20

var raycast_array : Array 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	raycast_array.append(Vector2(0,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
