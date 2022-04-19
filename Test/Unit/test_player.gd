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
	_player.take_life(4)
	
	assert_eq(Global.lives, 0, "Lives should not be less than 0")

func test_add_life():
	Global.lives = 2
	_player.take_life(-1)
	
	assert_eq(Global.lives, 3, "Lives should be 2 + 1")

func test_add_over_life():
	Global.lives = 3
	_player.take_life(-1)
	
	assert_eq(Global.lives, Global.MAX_LIVES, "Lives should not exceed "\
			+ str(Global.MAX_LIVES))
