extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var spawn_points : PoolVector2Array

onready var ysort = $YSort
onready var imp_node = preload("res://Enemies/Imp.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_points.append($SpawnPoints/Spawn.position)
	spawn_points.append($SpawnPoints/Spawn2.position)
	spawn_points.append($SpawnPoints/Spawn3.position)
	spawn_points.append($SpawnPoints/Spawn4.position)
	spawn_points.append($SpawnPoints/Spawn5.position)
	spawn_points.append($SpawnPoints/Spawn6.position)
	
	$YSort/Boss1.spawn_points = spawn_points


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Spawn_Timer_timeout() -> void:
	print("Spawning")
	var point = randi()%6
	var new_imp = imp_node.instance()
	new_imp.position = spawn_points[point]
	ysort.add_child(new_imp)
