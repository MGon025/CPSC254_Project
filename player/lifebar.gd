extends Sprite


func _ready():
	var player:	KinematicBody2D = get_node("../Player")
	if not player.is_connected("lives_changed", self, "_on_lives_changed"):
		player.connect("lives_changed", self, "_on_lives_changed")

	self.frame = Global.lives


func _on_lives_changed():
	self.frame = Global.lives
