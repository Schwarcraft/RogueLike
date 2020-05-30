extends KinematicBody2D

export (int) var base_speed = 200
export (int) var roll_speed = 500

var speed : int = base_speed
var roll_color : Color = Color(0,255,0)
var default_color : Color = Color(255,0,255,255)

var velocity = Vector2()

var is_rolling : bool = false
var is_selected : bool = false

func get_input():
	velocity = Vector2()
	if Input.is_action_just_pressed("select_cycle"):
		is_selected = !is_selected
		print(is_selected)
		if is_selected:
			$SelectedSprite.show()
		else:
			$SelectedSprite.hide()
	if is_selected:
		look_at(get_global_mouse_position())
		if Input.is_action_pressed('right'):
			velocity.x += 1
		if Input.is_action_pressed('left'):
			velocity.x -= 1
		if Input.is_action_pressed('down'):
			velocity.y += 1
		if Input.is_action_pressed('up'):
			velocity.y -= 1
		velocity = velocity.normalized() * speed
		
		if Input.is_action_just_pressed('roll'):
			if is_rolling == false:
				is_rolling = true
				$AnimatedSprite.modulate = roll_color
				speed=roll_speed
#				$AnimatedSprite.play("Roll")
				$RollTimer.start()
		
		

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)


func done_rolling():
	is_rolling = false
	speed = base_speed
	$AnimatedSprite.modulate = default_color


func _on_RollTimer_timeout() -> void:
	done_rolling() # Replace with function body.
