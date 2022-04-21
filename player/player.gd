extends KinematicBody2D

var speed: float = 100.0
var force: Vector2 = Vector2(speed, 0.0)

onready var move_sprite: Sprite = get_node("Move")
onready var death_sprite: Sprite = get_node("Death")
onready var anim_tree: AnimationTree = get_node("AnimationTree")
onready var life_bar: Sprite = get_node("../Lifebar")
onready var scoreboard: TextEdit = get_node("../Scoreboard")


func _ready():
	life_bar.frame = Global.lives
	scoreboard.text = str(Global.score)


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

	#TODO: Pause menu


func _physics_process(_delta):
	var curr_vel: Vector2 = movement()
	animation(curr_vel)


func animation(velocity: Vector2):
	# stop animation when velocity = (0,0)
	var movement_time: float = 1.0 if velocity else 0.0
	anim_tree.set("parameters/movement_time/scale", movement_time)

	# adjust rotation based on movement direction
	if force.y < 0.0:
		move_sprite.set_rotation(-PI / 2)
	elif force.x > 0.0:
		move_sprite.set_rotation(0.0)
	elif force.y > 0.0:
		move_sprite.set_rotation(PI / 2)
	elif force.x < 0.0:
		move_sprite.set_rotation(PI)


func movement() -> Vector2:
	if Input.is_action_just_pressed("ui_up"):
		force = Vector2(0.0, -speed)
	elif Input.is_action_just_pressed("ui_right"):
		force = Vector2(speed, 0.0)
	elif Input.is_action_just_pressed("ui_down"):
		force = Vector2(0.0, speed)
	elif Input.is_action_just_pressed("ui_left"):
		force = Vector2(-speed, 0.0)

	return move_and_slide(force)


func add_score(amount: int):
	# score should be between 0 and MAX_INT
	Global.score = int(max(Global.score + amount, 0))\
			if (Global.MAX_INT - Global.score) > amount\
			else Global.MAX_INT

	if scoreboard != null:
		scoreboard.text = str(Global.score)


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
		move_sprite.visible = false
		death_sprite.visible = true
		anim_tree.set("parameters/state/current", 1)

		print("player died. " + str(old_lives) + " - "\
				+ str(damage) + " = " + str(Global.lives))

	# healing
	elif damage < 0:
		#TODO: play healing sfx
		if life_bar != null:
			life_bar.frame = Global.lives

		print("player healed. " + str(old_lives) + " + "\
				+ str(damage) + " = " + str(Global.lives))


func respawn():
	# called by death animation
	if Global.lives == -1:
		Global.lives = Global.MAX_LIVES - 1
		Global.score = 0
		#TODO: Pause everything except player
		#TODO: choose restart game or go to main menu
		print("game over")

	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

