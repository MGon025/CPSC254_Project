extends Node2D


var score = 0


	
func _powerup_get():
	score = score + 100
	$score.text = "Score:" + str(score)

func _small_item_get():
	pass
	# $score.text = Global.score

func _big_item_get():
	score = score + 200
	$score.text = "Score:" + str(score)
