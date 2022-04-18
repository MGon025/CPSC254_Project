extends KinematicBody2D

const MAX_LIVES: int = 3
var lives: int = MAX_LIVES

var speed: float = 100.0
var force: Vector2 = Vector2(speed, 0.0)

onready var move_sprite: Sprite = get_node("Move")
onready var death_sprite: Sprite = get_node("Death")

func _input(_event):
	# for debbugging
	if Input.is_physical_key_pressed(KEY_Z):
		take_life(1)
	elif Input.is_physical_key_pressed(KEY_X):
		take_life(-1)

	#TODO: Pause menu

func _physics_process(_delta):
	var curr_vel: Vector2 = movement()
	animation(curr_vel)


func animation(velocity: Vector2):
	# stop animation when velocity = (0,0)
	var movement_time: float = 1.0 if velocity else 0.0
	$AnimationTree.set("parameters/movement_time/scale", movement_time)

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


func take_life(damage: int):
	# lives should always be between 0 and MAX_LIVES
	# warning-ignore:narrowing_conversion
	var old_life = lives
	lives = min(max(lives - damage, 0), MAX_LIVES)

	# early exit case for unit testing
	if move_sprite == null:
		return

	#TODO: death sequence
	if damage > 0:
		#TODO: Pause everything except player
		move_sprite.visible = false
		death_sprite.visible = true
		$AnimationTree.set("parameters/state/current", 1)

		print("player died. " + str(old_life) + " - "\
				+ str(damage) + " = " + str(lives))

	#TODO: healing sequence
	elif damage < 0:
		# play healing sfx

		print("player healed. " + str(old_life) + " + "\
				+ str(damage) + " = " + str(lives))

	#TODO: gameover sequence
	if lives == 0:
		#TODO: Pause everything except player
		#TODO: choose restart game or go to main menu
		print("game over")


func respawn():
	# called by death animation
	move_sprite.visible = true
	death_sprite.visible = false
	$AnimationTree.set("parameters/state/current", 0)
