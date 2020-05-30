extends CanvasLayer

onready var health_bar = $HealthBar
onready var health_text = $HealthText


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.connect("health_changed", self, "_update_health")


func _update_health():
	health_bar.value = GameData.player_health
	health_text.text = str(GameData.player_health) + "/" + str(GameData.player_max_health)
