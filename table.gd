extends Node

var p1_points = 0
var p2_points = 0

@onready var sound: AudioStreamPlayer = $sound

@onready var paddle_left: CharacterBody2D = $PaddleLeft
@onready var paddle_right: CharacterBody2D = $PaddleRight
@onready var ball: CharacterBody2D = $Ball

@onready var paddle_left_start: Marker2D = $PaddleLeftStart
@onready var paddle_right_start: Marker2D = $PaddleRightStart
@onready var ball_start: Marker2D = $BallStart

@onready var hud: CanvasLayer = $HUD

func point_to(side: int):
	if side == 0:
		p1_points += 1
		hud.set_p1_points(p1_points)
	
	if side == 1:
		p2_points += 1
		hud.set_p2_points(p2_points)

	sound.play()
	ball.destroy()
	await get_tree().create_timer(1.0).timeout
	new_round()

func new_round():
	paddle_left.move(paddle_left_start.position)
	paddle_right.move(paddle_right_start.position)
	ball.reset_speed()
	ball.move(ball_start.position)
	ball.serve()

func start_game(mode: String) -> void:
	await get_tree().create_timer(0.5).timeout
	paddle_left.enable_movement()
	paddle_right.enable_movement()
	if mode == "two":
		paddle_right.player_number = 1
	if mode == "single":
		paddle_right.player_number = 2
	ball.reset_speed()
	ball.serve()
