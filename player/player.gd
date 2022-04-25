extends KinematicBody2D

signal score_changed
signal lives_changed
signal powered_up
signal powered_down

enum Action {UP, RIGHT, DOWN, LEFT}

var _speed: float = 80.0
var _force: Vector2 = Vector2.ZERO
var _direction = null
var _curr_action = null
var _next_action = null
var _powered: bool = false

onready var _start_pos = get_position()

# animation nodes
onready var move_sprite: Sprite = get_node("Move")
onready var death_sprite: Sprite = get_node("Death")
onready var anim_tree: AnimationTree = get_node("AnimationTree")

# for queueing movement
onready var ray_down = [get_node("RayDown1"), get_node("RayDown2")]
onready var ray_up = [get_node("RayUp1"), get_node("RayUp2")]
onready var ray_right = [get_node("RayRight1"), get_node("RayRight2")]
onready var ray_left = [get_node("RayLeft1"), get_node("RayLeft2")]


func _ready():
	# _next_action = Action.RIGHT
	_direction = ray_right


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


func _queue_movement():
	if Input.is_action_just_pressed("ui_up"):
		_direction = ray_up
		_next_action = Action.UP
	elif Input.is_action_just_pressed("ui_right"):
		_direction = ray_right
		_next_action = Action.RIGHT
	elif Input.is_action_just_pressed("ui_down"):
		_direction = ray_down
		_next_action = Action.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		_direction = ray_left
		_next_action = Action.LEFT


func _physics_process(_delta):
	_queue_movement()
	_update_action()
	var curr_vel: Vector2 = _movement()
	_animation(curr_vel)


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
	anim_tree.set("parameters/movement_time/scale", movement_time)

	# adjust rotation based on movement direction
	if _force.y < 0.0:
		move_sprite.set_rotation(-PI / 2)
	elif _force.x > 0.0:
		move_sprite.set_rotation(0.0)
	elif _force.y > 0.0:
		move_sprite.set_rotation(PI / 2)
	elif _force.x < 0.0:
		move_sprite.set_rotation(PI)


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


func add_score(amount: int):
	# score should be between 0 and MAX_INT
	Global.score = int(max(Global.score + amount, 0))\
			if (Global.MAX_INT - Global.score) > amount\
			else Global.MAX_INT
	emit_signal("score_changed")


func power_up():
	print("player can kill")
	emit_signal("powered_up")
	_powered = !_powered
	#TODO: wait several seconds
	_powered = !_powered
	emit_signal("powered_down")


func take_life(damage: int):
	# lives should always be between 0 and MAX_LIVES
	var old_lives = Global.lives
	Global.lives = int(min(max(Global.lives - damage, -1), Global.MAX_LIVES))

	# early exit case for unit testing
	if move_sprite == null:
		return

	# death
	if damage > 0:
		#TODO: Pause everything except player
		set_physics_process(false)
		$CollisionShape2D.set_deferred("disabled", true)
		move_sprite.visible = false
		death_sprite.visible = true
		anim_tree.set("parameters/state/current", 1)

		print("player died. " + str(old_lives) + " - "\
				+ str(damage) + " = " + str(Global.lives))

	# healing
	elif damage < 0:
		#TODO: play healing sfx
		emit_signal("lives_changed")
		print("player healed. " + str(old_lives) + " + "\
				+ str(damage) + " = " + str(Global.lives))


func respawn():
	# called by player death animation
	if Global.lives == -1:
		Global.lives = Global.MAX_LIVES - 1
		Global.score = 0
		#TODO: Pause everything except player
		#TODO: choose restart game or go to main menu
		print("game over")

	set_position(_start_pos)
	set_physics_process(true)
	move_sprite.visible = true
	death_sprite.visible = false
	$CollisionShape2D.set_deferred("disabled", false)
	anim_tree.set("parameters/state/current", 0)
	_curr_action = null
	_next_action = null

