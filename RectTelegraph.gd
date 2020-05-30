extends Node2D

onready var progressBar = $TextureProgress
onready var timer = $AttackTimer

export var attackTime = 1
export var damage = 20
export var duration = 0

var attacking = false
var targets = []

var effect = null

var aim_target = null
var effect_target = null

signal attack_sent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = attackTime
	set_process(false)
	hide()

func _process(delta: float) -> void:
	if attacking:
		progressBar.value = 100 * ((timer.wait_time - timer.time_left) /timer.wait_time)

func _on_AttackTimer_timeout() -> void:
	attacking = false
	for target in targets:
		deal_damage(target)
	set_process(false)
	hide()
	emit_signal("attack_sent")

func _on_Area2D_body_entered(body: Node) -> void:
	targets.append(body)

func _on_Area2D_body_exited(body: Node) -> void:
	targets.erase(body)

func deal_damage(target):
	if target.has_method("take_damage"):
		target.take_damage(damage, duration)
		
func attack():
	if aim_target != null:
		look_at(aim_target.position)
		effect_target = $End.global_position 
	set_process(true)
	show()
	timer.wait_time=attackTime
	attacking = true
	timer.start()
