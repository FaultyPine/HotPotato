extends Control

@export var cup_move_speed = 1.0

var dest = Vector2.ZERO
var curr = Vector2.ZERO
var updown = false
var t = 0.0
var move_speed = 1.0
var has_flower = false
var can_be_picked = false

func is_finished_tween():
	return dest == Vector2.ZERO

# p1 is the point the curve won't pass through
# and p0 and p2 are points the curve will pass through
func quadratic_bezier(t: float, p0: Vector2, p1: Vector2, p2: Vector2):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r

func set_tween_dest(d: Vector2 = Vector2.ZERO, spotIdx: int = 0, speedMult: float = 1.0):
	dest = d
	curr = self.position
	updown = spotIdx % 2 == 0
	move_speed = cup_move_speed * speedMult
	move_speed += (-1 if spotIdx % 2 == 0 else 1) * 0.2
	t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_tween_dest()

func get_ctrl_point(p0: Vector2, p2: Vector2, updown: bool):
	var halfway: Vector2 = p0 + (p2 - p0) / 2.0
	var rand_mult = -1 if updown else 1
	halfway.y += rand_mult * 40
	return halfway

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if t > 1.0:
		set_tween_dest()
	if dest != Vector2.ZERO:
		self.position = quadratic_bezier(t, curr, get_ctrl_point(curr, dest, updown), dest)
		t += move_speed * delta

func set_cup_opacity(opacity: float):
	$CupSprite.modulate.a = opacity

func _on_gui_input(event):
	if event is InputEventScreenTouch:
		if can_be_picked:
			if has_flower:
				Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.SUCCESS)
			else:
				Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.FAILURE)
			get_node("../../").on_end()
