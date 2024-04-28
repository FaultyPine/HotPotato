extends Control

@onready var ball: RigidBody2D = $Ball
@onready var rows = $Pegs/Rows
@onready var columns = $Pegs/Columns
@onready var peg_container = $Pegs/PegContainer
@onready var slots = $Slots
var peg_scene = preload("res://Minigames/Pachinko/peg.tscn")

@export var max_ball_vel = 100.0
@export var ball_velocity_step = 100
@export var pegslot_ascend_speed = 3.0

func get_transition_text():
	return tr("PACHINKO_TRANSITION")

func _ready():
	ball.lock_rotation = true
	var num_cols = columns.get_child_count()
	for row in rows.get_children():
		var num_cols_filled = randi_range(2, 5)
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
	pass

func move_slots_and_pegs():
	for slot in slots.get_children():
		slot.position += Vector2.UP * pegslot_ascend_speed
	for peg in peg_container.get_children():
		peg.position += Vector2.UP * pegslot_ascend_speed

func move_ball(dir: float):
	if dir != 0:
		ball.constant_force = Vector2.ZERO
		ball.add_constant_central_force(Vector2(dir, 0.0))

var dir = 0
func _physics_process(delta):	
	move_slots_and_pegs()
	move_ball(dir * ball_velocity_step)

		
func _on_gui_input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch or event is InputEventMouseMotion:
		var tap_pos = event.position
		var viewport_size = get_viewport_rect().size
		if tap_pos.x < (viewport_size.x / 2.0): # left side of screen
			dir = -1
		else: # right side of screen
			dir = 1
	else:
		dir = 0
