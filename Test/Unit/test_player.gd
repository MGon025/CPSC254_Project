extends "res://addons/gut/test.gd"

var Player = load("res://player/Player.gd")
var _player = null

func before_each():
	_player = Player.new()

func after_each():
	_player.free()

func test_take_life():
	_player.lives = 3
	var result = _player.take_life(1)
	
	assert_eq(_player.lives, 2, "Lives should be 3 - 1")

func test_take_over_life():
	_player.lives = 3
	var result = _player.take_life(4)
	
	assert_eq(_player.lives, 0, "Lives should not be less than 0")

func test_add_life():
	_player.lives = 2
	var result = _player.take_life(-1)
	
	assert_eq(_player.lives, 3, "Lives should be 2 + 1")

func test_add_over_life():
	_player.lives = 3
	var result = _player.take_life(-1)
	
	assert_eq(_player.lives, _player.max_lives, "Lives should not exceed " + str(_player.max_lives))
