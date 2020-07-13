extends KinematicBody2D

export var speed : int = 2
export var attack_range : int = 40000
export var attack_damage : int = 10

var health : float 
export var max_health = 25

var Player = null
var target

var attacking = false
var is_done_spawning = false

var velocity : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player= GameData.player
	$AttackTelegraph/Timer.stop()
	$AttackTelegraph.hide()
	$AttackTelegraph.connect("attack_sent",self,"_die")
	health = max_health
	



func _physics_process(delta: float) -> void:
	if is_done_spawning and attacking == false:
				_attack()
		
func take_damage(damage : float):
	health -= damage
	$HealthBar/TextureProgress.value = (health/max_health) *100
	print((health/max_health) *100)
	if health <= 0:
		_die()

func _attack():
#	$AttackTelegraph.position = self.position
	$AnimatedSprite.play("Idle")
	$AttackTelegraph.show()
	$AttackTelegraph/Timer.start()
	attacking=true
	
func _reset_attack():
	attacking = false
	$AnimatedSprite.disconnect("animation_finished", self, "_reset_attack")


func _die():
	queue_free()


func _on_SpawnTimer_timeout() -> void:
	is_done_spawning = true
	$Particles2D.emitting = false
	$AnimatedSprite.playing = true
