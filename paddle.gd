extends CharacterBody2D

enum Player{One, Two, IA}

@export var speed = 450
@export var player_number: Player

var can_move = false
var screen_size
var player_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_size = $CollisionShape2D.shape.get_rect().size

func _is_player_one():
	return player_number == Player.One

func _is_player_two():
	return player_number == Player.Two
	
func _is_ia():
	return player_number == Player.IA

func is_move_up_pressed() -> bool:
	if _is_player_one():
		return Input.is_action_pressed("move_up")
	
	if _is_player_two():
		return Input.is_action_pressed("p2_move_up")
		
	return false

func is_move_down_pressed() -> bool:
	if _is_player_one():
		return Input.is_action_pressed("move_down")
		
	if _is_player_two():
		return Input.is_action_pressed("p2_move_down")
		
	return false

func enable_movement():
	can_move = true

func disable_movement():
	can_move = false

func _process(delta: float) -> void:
	if not can_move:
		return
		
	var velocity = Vector2.ZERO
	if is_move_up_pressed():
		velocity.y -= 1
	if is_move_down_pressed():
		velocity.y += 1
	
	if _is_ia():
		return calculate_movement()
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size-player_size)

func calculate_movement():
	var ball = get_tree().get_nodes_in_group("ball")[0] as VisibleOnScreenNotifier2D
	var ball_position = ball.global_position.y
	var half_screen = screen_size.x / 2
	if ball.global_position.x < half_screen:
		return
	position.y = lerpf(global_position.y, ball_position - (ball.rect.size.y / 2), 0.15)
	position = position.clamp(Vector2.ZERO, screen_size-player_size)
		
func move(pos) -> void:
	position = pos
