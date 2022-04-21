extends "res://addons/gut/test.gd"

var Player = load("res://player/player.gd")
var _player = null


func before_each():
	_player = Player.new()


func after_each():
	_player.free()


func test_take_life():
	Global.lives = 3
	_player.take_life(1)

	assert_eq(Global.lives, 2, "Lives should be 3 - 1")


func test_take_over_life():
	Global.lives = 3
	_player.take_life(5)

	assert_eq(Global.lives, -1, "Lives should not be less than -1")


func test_take_negative_life():
	Global.lives = 2
	_player.take_life(-1)

	assert_eq(Global.lives, 3, "Lives should be 2 + 1")


func test_take_negative_over_life():
	Global.lives = 3
	_player.take_life(-1)

	assert_eq(Global.lives, Global.MAX_LIVES, "Lives should not exceed "\
			+ str(Global.MAX_LIVES))


func test_add_score():
	Global.score = 1
	_player.add_score(10)

	assert_eq(Global.score, 11, "Score should be 10")


func test_add_negative_score():
	Global.score = 11
	_player.add_score(-10)

	assert_eq(Global.score, 1, "Score should be 1")


func test_add_score_not_negative():
	Global.score = 1
	_player.add_score(-20)
	
	assert_eq(Global.score, 0, "Score should not be less than 0")


func test_add_score_over_max_int():
	Global.score = Global.MAX_INT - 10
	_player.add_score(100)

	assert_eq(Global.score, Global.MAX_INT, "Score should not exceed max int")


func test_add_score_near_max_int():
	Global.score = Global.MAX_INT - 100
	_player.add_score(100)

	assert_eq(Global.score, Global.MAX_INT, "Score should be max int")

