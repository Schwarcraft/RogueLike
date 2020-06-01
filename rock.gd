extends KinematicBody2D

var target = Vector2()
var velocity = Vector2()

var speed = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = position.distance_to(target)/2
	$AnimationPlayer.play("spin")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if speed > 0:
		velocity = position.direction_to(target) * speed
		velocity = move_and_slide(velocity)



func _on_AnimationPlayer_animation_finished() -> void:
	GameData.screenShake()
	queue_free()
