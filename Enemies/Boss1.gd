extends KinematicBody2D

export var cast_radius = 300
export var number_of_points = 100
export var max_health = 250

onready var melee_attack = $RectTelegraph

var raycast_array : PoolVector2Array
var new_vector : Vector2
var health : float
var targets = []

export var damage = 10
export var duration = 0

var is_melee_attacking = false
var casting : bool = true

var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = GameData.player
#	melee_attack.connect("attack_sent",self,"reset_attack")
	health = max_health
	$Drawer.connect("done_casting",self, "deal_damage")
	var d_theta = 2*PI/number_of_points
	for i in range(number_of_points):
		new_vector.x = cast_radius*cos(d_theta*(i))
		new_vector.y = cast_radius*sin(d_theta*(i))
		raycast_array.append(new_vector)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if not casting and not is_melee_attacking and position.distance_squared_to(player.position)<2500:
		melee_attack.attack()
		is_melee_attacking = true
	
	
	
	if casting:
		var shape_array : PoolVector2Array 
		var space_state = get_world_2d().direct_space_state
		for ray in raycast_array:
			var result = space_state.intersect_ray(global_position, ray+global_position, [self],2)
			if result:
				shape_array.append(result.position-global_position)
			else:
				shape_array.append(ray)
		casting = false
		$Drawer.show()
		$DamageArea/CollisionPolygon2D.polygon = shape_array
		$Drawer.shape_array = shape_array
		$Drawer.is_casting = true
		$Drawer.update()
		$Drawer/Timer.start()


func _on_DamageArea_body_entered(body: Node) -> void:
	targets.append(body)
	print("in")

func _on_DamageArea_body_exited(body: Node) -> void:
	targets.erase(body)
	print("out")


func deal_damage():
	$MeleeAttackTimer.start()
	for target in targets:
		if target.has_method("player_take_damage"):
			target.player_take_damage(damage, duration)


func _on_CircleAttacktimer_timeout() -> void:
	$MeleeAttackTimer.stop()
	casting = true


func take_damage(damage : float):
	health -= damage
	$HealthBar/TextureProgress.value = (health/max_health) *100
	print((health/max_health) *100)
	if health <= 0:
		queue_free()


func _on_MeleeAttackTimer_timeout() -> void:
	is_melee_attacking = false

