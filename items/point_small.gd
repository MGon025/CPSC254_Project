extends Area2D


var _VALUE: int = 10


func _ready():
	if is_connected("body_entered", self, "_on_small_collision"):
		print("connected")
	else:
		print("connecting")
		connect("body_entered", self, "_on_small_collision")


func _on_small_collision(body):
	print("entered")
	if "Player" in body.name:
		body.add_score(_VALUE)
		queue_free()
