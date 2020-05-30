extends Node2D

var center = Vector2(3,3)
var radius = 1
var attackRange = 50
#var color = Color(255, 15, 15, 1)
var color = Color(0.99,0.3,0.3,0.5)
var time = 2
var damage = 50
var duration = 0
var targets = []


func _ready() -> void:
	$Timer.wait_time = time
	$Timer.start()
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
	queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	targets.append(body)


func _on_Area2D_body_exited(body: Node) -> void:
	targets.erase(body)

func deal_damage(target, damage):
	print("trying to deal damage")
	if target.has_method("take_damage"):
		target.take_damage(damage, duration)
