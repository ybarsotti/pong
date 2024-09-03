extends CanvasLayer

@onready var p_1_points: Label = $p1_points 
@onready var p_2_points: Label = $p2_points
@onready var ip_field: TextEdit = $ip_field

signal start(mode: String)

func set_p1_points(point: int):
	p_1_points.text = str(point)
	
func set_p2_points(point: int):
	p_2_points.text = str(point)

func start_game(mode: String) -> void:
	if mode == "join":
		if Server.join_game(ip_field.text):
			start.emit(mode)
	else:
		start.emit(mode)
	get_tree().call_group("buttons", "hide")
