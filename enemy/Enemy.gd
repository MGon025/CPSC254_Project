extends KinematicBody2D

var speed: int = 100
var force: Vector2 = Vector2(speed, 0.0)
var current_direction: int = 1 # 0 = UP, 1 = RIGHT, 2 = DOWN, 3 = LEFT

func _physics_process(_delta):
	var curr_vel: Vector2 = movement()
	animation(curr_vel)

func animation(velocity: Vector2):
	# stop animation when velocity = (0,0)
	$AnimationTree.active = true if velocity else false

	# adjust sprite rotation based on movement direction
	if force.y < 0:
		$Sprite.frame_coords.y = 2
	elif force.x > 0:
		$Sprite.frame_coords.y = 1
	elif force.y > 0:
		$Sprite.frame_coords.y = 0
	elif force.x < 0:
		$Sprite.frame_coords.y = 3

func movement() -> Vector2:
	if rand_range(0, 1) <= 0.3: # 30% chance to change direction.
		if rand_range(0, 1) <= 0.5:
			current_direction += 1
		else:
			current_direction -= 1
	
	if current_direction % 4 == 0:
		force = Vector2(0, -speed)
	elif current_direction % 4 == 1:
		force = Vector2(speed, 0)
	elif current_direction % 4 == 2:
		force = Vector2(0, speed)
	elif current_direction % 4 == 3:
		force = Vector2(-speed, 0)
	
	return move_and_slide(force)
