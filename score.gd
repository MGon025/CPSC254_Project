extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_node("../Player")
	if player.is_connected("score_changed", self, "_on_score_changed"):
		print('player connected')
	else:
		print('player connecting')
		player.connect("score_changed", self, "_on_score_changed")

	self.text = "Score: " + str(Global.score)


func _on_score_changed():
	self.text = "Score: " + str(Global.score)
