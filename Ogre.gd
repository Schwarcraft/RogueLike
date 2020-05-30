extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
onready var timer : Timer = $SlamAttackTimer
onready var rect_attack = $RectTelegraph

onready var anim_player = $AnimatedSprite

onready var effect = preload("res://DustCloud.tscn")
onready var rock = preload("res://rock.tscn")
onready var circle = preload("res://AttackTelegraph.tscn")

export var max_health = 100


var has_target : bool = false
var target= null

var health

func _ready() -> void:
	rect_attack.connect("attack_sent",self,"play_slam_attack")
	var timer_mod = randf()
	$SlamAttackTimer.wait_time += timer_mod/2
	
	health = max_health


func _on_SlamAttackTimer_timeout() -> void:
	if target != null:
		var attack_type = randi()%2
		if attack_type == 0:
			rect_attack.attack()
		else:
			anim_player.play("Throw")
			anim_player.connect("animation_finished",self,"_throw_rock")


func play_slam_attack():
	anim_player.play("Attack")
	anim_player.connect("frame_changed",self,"_send_dust_cloud")
	anim_player.connect("animation_finished",self,"play_hold")

	
func play_hold():
	anim_player.disconnect("animation_finished",self,"play_hold")
	anim_player.play("Hold")
	

func _send_dust_cloud():
	if $AnimatedSprite.frame == 2:
		GameData.screenShake()
		var new_effect = effect.instance()
		new_effect.target=($RectTelegraph.effect_target)
		new_effect.position = global_position
		get_tree().get_root().add_child(new_effect)
		anim_player.disconnect("frame_changed",self,"_send_dust_cloud")


func _on_Aggro_body_entered(body: Node) -> void:
	if body.name == "Player":
		target = body
		$Aggro.set_process(false)
		rect_attack.aim_target = body


func _throw_rock():
	anim_player.disconnect("animation_finished",self,"_throw_rock")
	var new_rock = rock.instance()
	new_rock.position = $RockSpawnPosition.global_position
	new_rock.target = target.position
	new_rock.scale = scale
	get_tree().get_root().add_child(new_rock)
	anim_player.play("Hold")
	var currentAttack = circle.instance()
	currentAttack.center = target.global_position
	get_tree().get_root().add_child(currentAttack)

func take_damage(damage : float):
	health -= damage
	$HealthBar/TextureProgress.value = (health/max_health) *100
	if health <= 0:
		queue_free()

	
