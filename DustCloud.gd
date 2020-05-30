extends KinematicBody2D

var target : Vector2 

export var speed = 500

var velocity : Vector2

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = position.direction_to(target) *speed
	velocity = move_and_slide(velocity)
	
	if position.distance_squared_to(target) < 400 :
		queue_free()
