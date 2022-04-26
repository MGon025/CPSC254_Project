extends KinematicBody2D

var speed: int = 100
var force: Vector2 = Vector2(speed, 0.0)
var _current_direction: int = -1 # -1 = No Movement, 0 = UP, 1 = RIGHT, 2 = DOWN, 3 = LEFT

onready var anim_tree: AnimationTree = get_node("AnimationTree")
onready var player: KinematicBody2D = get_node("../Player")


var _num_valid_directions: int = 0

# for detecting opportunities to change direction
onready var ray_down = [get_node("RayDown1"), get_node("RayDown2")]
onready var ray_up = [get_node("RayUp1"), get_node("RayUp2")]
onready var ray_right = [get_node("RayRight1"), get_node("RayRight2")]
onready var ray_left = [get_node("RayLeft1"), get_node("RayLeft2")]

func _ready():
	_current_direction = choose_direction()

func _physics_process(_delta):
	var curr_vel: Vector2 = movement()
	animation(curr_vel)
	if !curr_vel:
		_current_direction = choose_direction()
	
	check_player_collision()

func animation(velocity: Vector2):
	# stop animation when velocity = (0,0)
	var movement_time: float = 1.0 if velocity else 0.0
	anim_tree.set("parameters/movement_time/scale", movement_time)

	# change row on spritesheet depending on direction of movement
	if force.y < 0:
		$Sprite.frame_coords.y = 0
	elif force.x > 0:
		$Sprite.frame_coords.y = 1
	elif force.y > 0:
		$Sprite.frame_coords.y = 2
	elif force.x < 0:
		$Sprite.frame_coords.y = 3

func movement() -> Vector2:
	var curr_num_valid_dirs = _num_valid_directions
	_num_valid_directions = check_num_valid_directions()
	if curr_num_valid_dirs < _num_valid_directions:
		_current_direction = choose_direction()
		
	# Apply force according to desired direction.
	if _current_direction == 0:
		force = Vector2(0, -speed)
	elif _current_direction == 1:
		force = Vector2(speed, 0)
	elif _current_direction == 2:
		force = Vector2(0, speed)
	elif _current_direction == 3:
		force = Vector2(-speed, 0)
	
	return move_and_slide(force)
	
func choose_direction() -> int:
	# randomly chooses a valid direction to move towards
	var valid_directions: Array = [0, 1, 2, 3]
	for raycast in ray_up:
		if raycast.get_collider() is TileMap:
			valid_directions.remove(valid_directions.find(0))
	for raycast in ray_right:
		if raycast.get_collider() is TileMap:
			valid_directions.remove(valid_directions.find(1))
	for raycast in ray_down:
		if raycast.get_collider() is TileMap:
			valid_directions.remove(valid_directions.find(2))
	for raycast in ray_left:
		if raycast.get_collider() is TileMap:
			valid_directions.remove(valid_directions.find(3))
	return valid_directions[randi() % valid_directions.size()]

func check_num_valid_directions() -> int:
	# counts the number of valid movement directions
	var num_valid = 0
	var temp = 1
	if _current_direction != 2:
		for raycast in ray_up:
			if raycast.get_collider() is TileMap:
				temp = 0
		num_valid += temp
	temp = 1
	if _current_direction != 0:
		for raycast in ray_down:
			if raycast.get_collider() is TileMap:
				temp = 0
		num_valid += temp
	temp = 1
	if _current_direction != 3:
		for raycast in ray_left:
			if raycast.get_collider() is TileMap:
				temp = 0
		num_valid += temp
	temp = 1
	if _current_direction != 1:
		for raycast in ray_right:
			if raycast.get_collider() is TileMap:
				temp = 0
		num_valid += temp
	
	return num_valid
	
func die():
	print("The enemy died!")

func check_player_collision():
	for i in get_slide_count():
		if get_slide_collision(i).collider == player:
			if player._powered:
				die()
			else:
				player.take_life(1)
