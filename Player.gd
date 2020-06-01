extends KinematicBody2D

export (int) var base_speed = 200
export (int) var roll_speed = 400
export (int) var max_health = 100

var health
onready var spirit_node = preload("res://Spirit.tscn")
var speed : int = base_speed
var roll_color : Color = Color(0,255,0)
var default_color : Color = Color(255,255,100,255)

var velocity = Vector2()
var spirit

var is_rolling : bool = false
var is_selected : bool = true
var is_spirit_summoned : bool = false

var attacking : bool = false

func _ready() -> void:
	GameData.player = self
	health = max_health

func get_input():
	velocity = Vector2()
	if Input.is_action_just_pressed("select_cycle"):
		if is_spirit_summoned:
			is_selected = !is_selected
			if is_selected:
				$SelectedSprite.show()
			else:
				$SelectedSprite.hide()
	if is_selected && not attacking: 
		if Input.is_action_pressed('right'):
			velocity.x += 1
		if Input.is_action_pressed('left'):
			velocity.x -= 1
		if Input.is_action_pressed('down'):
			velocity.y += 1
		if Input.is_action_pressed('up'):
			velocity.y -= 1
	
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false

		velocity = velocity.normalized() * speed
		if velocity == Vector2(0,0):
			$AnimatedSprite.play("Idle")
		else:
			$AnimatedSprite.play("Walking")
		
#		if Input.is_action_just_pressed("attack"):
#			if attacking == false:
#				speed=0
#				velocity = Vector2(0,0)
#				attacking = true
#				var angle = get_angle_to(get_global_mouse_position())
#				if angle >= -PI/4 and angle <= PI/4:
#					$AnimatedSprite.flip_h = false
#					$AnimatedSprite.play("AttackSide")
#				elif angle > PI/4 and angle <= 3*PI/4:
#					$AnimatedSprite.play("AttackDown")
#				elif abs(angle) > 3*PI/4:
#					$AnimatedSprite.flip_h = true
#					$AnimatedSprite.play("AttackSide")
#				else:
#					$AnimatedSprite.play("AttackUp")
#				$AnimatedSprite.connect("animation_finished", self, "_reset_attack")
				
		if Input.is_action_just_pressed('roll'):
			if is_rolling == false:
				is_rolling = true
				if velocity == Vector2():
					velocity = Vector2(1.0, 0.0)
				speed=roll_speed
				$HitBox.disabled = true
				$AnimatedSprite.play("Roll")
				if $AnimatedSprite.flip_h == false:
					$AnimationPlayer.play("Roll")
				else:
					$AnimationPlayer.play("Roll_hflip")
				$RollTimer.start()
		if Input.is_action_just_pressed("interact_spirit"):
			if not is_spirit_summoned:
				is_spirit_summoned = true
				spirit = spirit_node.instance()
				spirit.position = get_global_mouse_position()
				get_parent().add_child(spirit)
			else:
				spirit.queue_free()
				spirit = null
				is_spirit_summoned = false
			
		

func _physics_process(delta):
	if not is_rolling:
		get_input()
	else:
		velocity = velocity.normalized()*roll_speed
	velocity = move_and_slide(velocity)

func done_rolling():
	is_rolling = false
	speed = base_speed
	$HitBox.disabled = false

func _on_RollTimer_timeout() -> void:
	done_rolling() # Replace with function body.
	
func _reset_attack() -> void:
	$AnimatedSprite.disconnect("animation_finished", self, "_reset_attack")
	attacking = false
	speed = base_speed
	$AnimatedSprite.play("Idle")
	$AnimatedSprite.flip_h = false


func take_damage(damage, duration):
	if duration == 0:
		health -= damage
		GameData.player_health = health
		GameData.update_health()
	if health <= 0:
		health=0
		_die()
			

func _die():
	GameData.game_over()
	

