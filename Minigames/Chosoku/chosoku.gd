extends Control

@onready var circleFollow = $CircleFollow
@onready var circleRepositionTimer = $CircleRepositionTimer
@onready var circleSpots = $Person/CircleSpots
@onready var progressBar = $ProgressBar

@export var circleInterpolationSpeedMult = 0.2
@export var progressTick = 0.2

var is_in_circle = false
var progress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	circleRepositionTimer.start()
	progress = 0
	is_in_circle = false


var t = 0.0
var circleDest = Vector2.ZERO
func _process(delta):
	if circleDest != Vector2.ZERO:
		t += delta * circleInterpolationSpeedMult
		circleFollow.position = circleFollow.position.lerp(circleDest, t)
	if is_in_circle:
		progress += progressTick
	else:
		progress -= progressTick/2.0
	progressBar.value = progress
	if progress >= progressBar.max_value:
		Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.SUCCESS)

func reposition_circle():
	var possibleCircleSpots = circleSpots.get_children()
	var idx = randi_range(0, len(possibleCircleSpots)-1)
	var newSpot = possibleCircleSpots[idx].position
	circleDest = newSpot
	t = 0

func on_touch_in_circle(is_in: bool):
	is_in_circle = is_in

func _on_area_2d_input_event(viewport, event, shape_idx):
	# called on input events with our CircleFollow
	if event is InputEventScreenTouch:
		if event.is_pressed():
			on_touch_in_circle(true)
		elif event.is_released():
			on_touch_in_circle(false)
	if event is InputEventScreenDrag:
		on_touch_in_circle(true)
func _on_area_2d_mouse_exited():
	on_touch_in_circle(false)


func _on_circle_reposition_timer_timeout():
	reposition_circle()
	circleRepositionTimer.wait_time = randf_range(1.0, 2.0)
	circleRepositionTimer.start()

func get_transition_text():
	return "STAY CALM\nKEEP FINGER INSIDE CIRCLE"
	
func get_minigame_time():
	return 15.0
