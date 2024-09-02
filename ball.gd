extends CharacterBody2D

enum Side{LEFT, RIGHT}

const MIN_SPEED = 300

@export var speed = 300
@export var SPEED_INCREMENT = 5
@export var MAXIMUM_SPEED = 700

@onready var sound: AudioStreamPlayer = $Sound

var direction: Vector2 = Vector2.ZERO

signal exited(side: Side)

func _ready():
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * speed * delta)
	rotate(0.1 + speed * 0.00001)
	if collision:
		if collision.get_collider() is StaticBody2D:
			sound.stream = preload("res://sound/beep.ogg")
		else:
			sound.stream = preload("res://sound/plop.ogg")
		velocity = velocity.bounce(collision.get_normal())
		sound.play()
		

func destroy():
	hide()

func move(pos) -> void:
	show()
	position = pos

func reset_speed():
	speed = MIN_SPEED

func serve():
	direction = Vector2([-1, 1].pick_random(), [-1, 1].pick_random())
	velocity = direction.normalized()
	set_physics_process(true)

func _on_speed_up_timer_timeout() -> void:
	speed += SPEED_INCREMENT
	if speed >= MAXIMUM_SPEED:
		$SpeedUpTimer.stop()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if position.x < 0:
		exited.emit(Side.LEFT)
		return
	exited.emit(Side.RIGHT)
