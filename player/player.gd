#	 Code relating to player's movement and interactions with the world.
#    Copyright (C) 2022  Mark Gonzalez
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see https://www.gnu.org/licenses/.


extends KinematicBody2D

# received by scoreboard and lifebar respectively
signal score_changed
signal lives_changed

# received by enemy for transitioning in/out of weakened state
signal powered_up
signal powered_down

# enum for movement direction
enum Action {UP, RIGHT, DOWN, LEFT}

# for enemy interactions
var powered: bool = false
var _power_time: int = 5

# for movement
var _speed: float = 80.0
var _force: Vector2 = Vector2.ZERO
var _direction = null
var _curr_action = null
var _next_action = null

# for respawning
onready var _start_pos = get_position()

# animation nodes
onready var _move_sprite: Sprite = get_node("Move")
onready var _death_sprite: Sprite = get_node("Death")
onready var _anim_tree: AnimationTree = get_node("AnimationTree")

# for queueing movement
onready var _ray_down = [get_node("RayDown1"), get_node("RayDown2")]
onready var _ray_up = [get_node("RayUp1"), get_node("RayUp2")]
onready var _ray_right = [get_node("RayRight1"), get_node("RayRight2")]
onready var _ray_left = [get_node("RayLeft1"), get_node("RayLeft2")]


func _ready():
	# _next_action = Action.RIGHT
	_direction = _ray_right


func _input(_event):
	# for debbugging
	if Input.is_physical_key_pressed(KEY_Z):
		take_life(1)
	elif Input.is_physical_key_pressed(KEY_X):
		take_life(-1)
	elif Input.is_physical_key_pressed(KEY_C):
		add_score(10)
	elif Input.is_physical_key_pressed(KEY_V):
		add_score(100)
	elif Input.is_physical_key_pressed(KEY_B):
		add_score(-100)
	elif Input.is_physical_key_pressed(KEY_M):
		power_up()


func _physics_process(_delta):
	_queue_movement()
	_update_action()
	var curr_vel: Vector2 = _movement()
	_animation(curr_vel)


func add_score(amount: int):
	# score should be between 0 and MAX_INT
	Global.score = int(max(Global.score + amount, 0))\
			if (Global.MAX_INT - Global.score) > amount\
			else Global.MAX_INT
	emit_signal("score_changed")


func power_up():
	print("player can kill")
	emit_signal("powered_up")
	powered = !powered
	$Timer.set_wait_time(_power_time)
	$Timer.start()
	yield($Timer, "timeout")
	powered = !powered
	emit_signal("powered_down")
	print("player cannot kill")


func take_life(damage: int = 1):
	# lives should always be between 0 and MAX_LIVES
	var old_lives = Global.lives
	Global.lives = int(min(max(Global.lives - damage, -1), Global.MAX_LIVES))

	# early exit case for unit testing
	if _move_sprite == null:
		return

	# death
	if damage > 0:
		#TODO: Pause everything except player
		set_physics_process(false)
		$CollisionShape2D.set_deferred("disabled", true)
		_move_sprite.visible = false
		_death_sprite.visible = true
		_anim_tree.set("parameters/state/current", 1)

		print("player died. " + str(old_lives) + " - "\
				+ str(damage) + " = " + str(Global.lives))

	# healing
	elif damage < 0:
		#TODO: play healing sfx
		emit_signal("lives_changed")
		print("player healed. " + str(old_lives) + " + "\
				+ str(damage) + " = " + str(Global.lives))


func _queue_movement():
	if Input.is_action_just_pressed("ui_up"):
		_direction = _ray_up
		_next_action = Action.UP
	elif Input.is_action_just_pressed("ui_right"):
		_direction = _ray_right
		_next_action = Action.RIGHT
	elif Input.is_action_just_pressed("ui_down"):
		_direction = _ray_down
		_next_action = Action.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		_direction = _ray_left
		_next_action = Action.LEFT


func _update_action():
	var change_action: bool = true
	for raycast in _direction:
		if raycast.get_collider() is TileMap:
			change_action = false
	if change_action:
		_curr_action = _next_action


func _animation(velocity: Vector2):
	# stop animation when velocity = (0,0)
	var movement_time: float = 1.0 if velocity else 0.0
	_anim_tree.set("parameters/movement_time/scale", movement_time)

	# adjust sprite based on movement direction
	if _force.y < 0.0:
		_move_sprite.set_rotation(-PI / 2)
	elif _force.x > 0.0:
		_move_sprite.set_rotation(0.0)
	elif _force.y > 0.0:
		_move_sprite.set_rotation(PI / 2)
	elif _force.x < 0.0:
		_move_sprite.set_rotation(PI)


func _movement() -> Vector2:
	match _curr_action:
		Action.UP:
			_force = Vector2(0.0, -_speed)
		Action.RIGHT:
			_force = Vector2(_speed, 0.0)
		Action.DOWN:
			_force = Vector2(0.0, _speed)
		Action.LEFT:
			_force = Vector2(-_speed, 0.0)
		_:
			_force = Vector2.ZERO

	return move_and_slide(_force)


func _respawn():
	# called by player death animation
	if Global.lives == -1:
		Global.lives = Global.MAX_LIVES - 1
		Global.score = 0
		#TODO: Pause everything except player
		#TODO: choose restart game or go to main menu
		print("game over")

	set_position(_start_pos)
	set_physics_process(true)
	_move_sprite.visible = true
	_death_sprite.visible = false
	$CollisionShape2D.set_deferred("disabled", false)
	_anim_tree.set("parameters/state/current", 0)
	_curr_action = null
	_next_action = null

