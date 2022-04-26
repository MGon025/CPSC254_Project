extends Area2D


var _VALUE: int = 500


func _ready():
	if not is_connected("body_entered", self, "_on_big_collision"):
		connect("body_entered", self, "_on_big_collision")


func _on_big_collision(body):
	if "Player" in body.name:
		body.add_score(_VALUE)
		queue_free()
