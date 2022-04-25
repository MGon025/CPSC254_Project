extends Area2D


var _VALUE: int = 100

func _ready():
	if is_connected("body_entered", self, "_on_powerup"):
		print("connected")
	else:
		print("connecting")
		connect("body_entered", self, "_on_powerup")


func _on_powerup(body):
	print("entered")
	if "Player" in body.name:
		body.add_score(_VALUE)
		body.power_up()
		queue_free()
