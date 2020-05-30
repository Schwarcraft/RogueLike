extends Node

# Called when the node enters the scene tree for the first time.
var player = null
var spirit = null

var player_health : int = 100
var player_max_health : int = 100

onready var game_over_screen = preload("res://GameOver.tscn")

signal shake_screen
signal health_changed
func _ready() -> void:
	pass # Replace with function body.

func screenShake():
	emit_signal("shake_screen")


func update_health():
	emit_signal("health_changed")


func game_over():
	var over_screen = game_over_screen.instance()
	add_child(over_screen)
	get_tree().paused = true
