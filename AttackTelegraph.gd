extends Node2D

var center = Vector2(3,3)
var radius = 1
export var attackRange = 50
#var color = Color(255, 15, 15, 1)
var color = Color(0.99,0.3,0.3,0.3)
export var time = 2
var damage = 50
var duration = 0
var targets = []

signal attack_sent

func _ready() -> void:
	hide()
	$Timer.wait_time = time
#	$Timer.start()
	$Area2D/CollisionShape2D.shape.radius=attackRange
	position = center
	
func _process(delta):
		radius = attackRange * ( ($Timer.wait_time - $Timer.time_left) /$Timer.wait_time)
		update()

func _draw():
	draw_circle(Vector2(0,0), radius, color)
	draw_circle(Vector2(0,0), attackRange, color)



func _on_Timer_timeout() -> void:
	for target in targets:
		deal_damage(target, damage)
		print(target)
	emit_signal("attack_sent")
	queue_free()
	


func _on_Area2D_body_entered(body: Node) -> void:
	targets.append(body)


func _on_Area2D_body_exited(body: Node) -> void:
	targets.erase(body)

func deal_damage(target, damage):
	print("trying to deal damage")
	if target.has_method("player_take_damage"):
		target.player_take_damage(damage, duration)
	elif target.has_method("env_take_damage"):
		target.env_take_damage()
