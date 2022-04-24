extends Area2D


signal small_point


func _on_small_collision(body):
	if "Player" in body.name:
		emit_signal("small_point")
		queue_free()
