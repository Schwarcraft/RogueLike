extends KinematicBody2D

export var speed : int = 3
export var attack_range : int = 4000
export var attack_damage : int = 10

onready var rect_attack = $RectTelegraph
var health : float 
export var max_health = 50

var Player = null
var target
var attacking = false

var velocity : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player= GameData.player
	health = max_health
	$RectTelegraph.aim_target = Player
	$RectTelegraph.damage = attack_damage
	$RectTelegraph.attackTime = 0.5
	



func _physics_process(delta: float) -> void:
	target = Player.global_position
	velocity = position.direction_to(target) * speed
	if attacking == false:
		if velocity.y < -0.3:
				$AnimatedSprite.play("WalkUp")
		elif velocity.x > 0.2:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("WalkSide")
		elif velocity.x < -0.2:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("WalkSide")
		elif velocity.y > 0: 
			$AnimatedSprite.play("WalkDown")

		if position.distance_squared_to(target) > attack_range:
			move_and_collide(velocity)
		else:
			_attack()
		
func take_damage(damage : float):
	health -= damage
	$HealthBar/TextureProgress.value = (health/max_health) *100
	print((health/max_health) *100)
	if health <= 0:
		_die()


func _attack():
	var anim_string : String
	rect_attack.attack()
	attacking = true
	if velocity.x <0:
		$AnimatedSprite.flip_h = true
	if velocity.y < -0.3:
		anim_string = "Down"
	else:
		anim_string = "Side"
	$AnimatedSprite.play(anim_string)
	$AnimatedSprite.connect("animation_finished", self, "_reset_attack")
	
func _reset_attack():
	attacking = false
	$AnimatedSprite.disconnect("animation_finished", self, "_reset_attack")


func _die():
	queue_free()
