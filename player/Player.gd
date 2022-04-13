extends KinematicBody2D

var speed: int = 100
var velocity: Vector2 = Vector2(speed, 0.0)
onready var sprite: Sprite = get_node("Sprite")

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		velocity = Vector2(0, -speed)
	elif Input.is_action_just_pressed("ui_right"):
		velocity = Vector2(speed, 0)
	elif Input.is_action_just_pressed("ui_down"):
		velocity = Vector2(0, speed)
	elif Input.is_action_just_pressed("ui_left"):
		velocity = Vector2(-speed, 0)

	move_and_slide(velocity)

	# adjust sprite rotation based on move direction
	if velocity.y < 0:
		sprite.set_rotation(-PI/2)
	elif velocity.x > 0:
		sprite.set_rotation(0.0)
	elif velocity.y > 0:
		sprite.set_rotation(PI/2)
	elif velocity.x < 0:
		sprite.set_rotation(PI)
