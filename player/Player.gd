extends KinematicBody2D

var max_lives: int = 3
var lives: int = max_lives

var speed: int = 100
var force: Vector2 = Vector2(speed, 0.0)

func _physics_process(_delta):
	var curr_vel: Vector2 = movement()
	animation(curr_vel)

func animation(velocity: Vector2):
	# stop animation when velocity = (0,0)
	$AnimationTree.active = true if velocity else false

	# adjust sprite rotation based on movement direction
	if force.y < 0:
		$Sprite.set_rotation(-PI/2)
	elif force.x > 0:
		$Sprite.set_rotation(0.0)
	elif force.y > 0:
		$Sprite.set_rotation(PI/2)
	elif force.x < 0:
		$Sprite.set_rotation(PI)

func movement() -> Vector2:
	if Input.is_action_just_pressed("ui_up"):
		force = Vector2(0, -speed)
	elif Input.is_action_just_pressed("ui_right"):
		force = Vector2(speed, 0)
	elif Input.is_action_just_pressed("ui_down"):
		force = Vector2(0, speed)
	elif Input.is_action_just_pressed("ui_left"):
		force = Vector2(-speed, 0)
	
	return move_and_slide(force)

func take_life(damage: int):
	# lives should always be between 0 and max_lives
	lives = min(max(lives-damage, 0), max_lives)
