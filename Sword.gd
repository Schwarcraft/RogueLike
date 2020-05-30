extends Node2D

var Player

var damage = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	look_at(get_global_mouse_position())
	if $Sprite.global_position.x > Player.global_position.x:
		$Sprite.flip_v = false
	else:
		$Sprite.flip_v = true

	if Input.is_action_just_pressed("attack"):
		if Player.is_rolling == false:
			$Sprite/Area2D/CollisionShape2D.disabled=false
			$Sprite/AnimationPlayer.play("Attack")


func _on_Area2D_body_entered(body: Node) -> void:
	body.take_damage(damage)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	$Sprite/Area2D/CollisionShape2D.disabled=true
