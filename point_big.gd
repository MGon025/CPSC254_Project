extends Area2D


signal big_point


func _on_big_collision(body):
	if "Player" in body.name:
		emit_signal("big_point")
		queue_free()
