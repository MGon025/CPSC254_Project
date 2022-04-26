extends Area2D


var _VALUE: int = 100

func _ready():
	if not is_connected("body_entered", self, "_on_powerup"):
		connect("body_entered", self, "_on_powerup")


func _on_powerup(body):
	if "Player" in body.name:
		body.add_score(_VALUE)
		body.power_up()
		queue_free()
