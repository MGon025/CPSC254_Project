extends Area2D


signal powerup


func _on_powerup(body):
	if "Player" in body.name:
		emit_signal("powerup")
		queue_free()
