extends Control

@onready var ball: RigidBody2D = $Ball
@onready var rows = $Pegs/Rows
@onready var columns = $Pegs/Columns
@onready var peg_container = $Pegs/PegContainer
@onready var slots = $Slots
var peg_scene = preload("res://Minigames/Pachinko/peg.tscn")

@export var max_ball_vel = 100.0
@export var ball_velocity_step = 10

func get_transition_text():
	return tr("PACHINKO_TRANSITION")

func _ready():
	var num_cols = columns.get_child_count()
	for row in rows.get_children():
		var num_cols_filled = randi_range(0, 3)
		for i in range(num_cols_filled):
			var cols_chosen = []
			var rand_col_idx = randi_range(0, num_cols-1)
			while rand_col_idx in cols_chosen:
				rand_col_idx = randi_range(0, num_cols-1)
			cols_chosen.append(rand_col_idx)
			var col = columns.get_child(rand_col_idx)
			spawn_peg(row, col)

func spawn_peg(row: Node2D, col: Node2D):
	var peg = peg_scene.instantiate()
	peg.position = Vector2(col.position.x, row.position.y)
	peg_container.add_child(peg)

func _process(delta):
	slots.position.y -= 2.0

func is_on_side():
	var margin = 10	
	var viewport_size = get_viewport_rect().size	
	if ball.position.x < margin:
		return [true, 1.0 * ball_velocity_step]
	if ball.position.x > viewport_size.x-margin:
		return [true, -1.0 * ball_velocity_step]
	return [false, 0.0]

func _physics_process(delta):	
	var on_side = is_on_side()
	if on_side[0]:
		ball.constant_force.x = on_side[1]
		ball.linear_velocity.x = 0

func move_ball(dir: float):
	var should_halt = sign(dir) != sign(ball.constant_force.x) # if we switch directions make it snappy
	if should_halt:
		ball.constant_force.x = dir
		ball.linear_velocity.x = 0
	if abs(dir + ball.constant_force.x) < max_ball_vel:
		ball.add_constant_central_force(Vector2(dir, 0.0))

		
func _on_gui_input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
		var tap_pos = event.position
		var viewport_size = get_viewport_rect().size
		if tap_pos.x < (viewport_size.x / 2.0): # left side of screen
			move_ball(-1 * ball_velocity_step)
		else: # right side of screen
			move_ball(1 * ball_velocity_step)
