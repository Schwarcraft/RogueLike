extends StaticBody2D

var counter :int =0

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func env_take_damage():
	counter += 1
	if counter == 1:
		$HealthySprite.hide()
		$CrackedSprite.show()
	else:
		queue_free()
		
