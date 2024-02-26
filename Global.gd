extends Node

enum MinigameCompleteStatus
{
	TIMEOUT,
	FAILURE,
	SUCCESS,
}

# global events lots of scripts might care about
signal on_drag_signal(start, end, duration)
signal on_ingame_pause_signal
signal on_ingame_minigame_over_signal(minigame_complete_status: MinigameCompleteStatus)


# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("dev_quit"):
		get_tree().quit()

func get_main_root() -> MainRoot:
	var root = get_node("/root/MainRoot")
	assert(root is MainRoot)
	return root

func on_drag(start: Vector2, end: Vector2, duration: float):
	print("Drag: " + str(start) + " -> " + str(end) + " | " + str(duration) + "msec")
	on_drag_signal.emit(start, end, duration)

var pressed_down: bool = false
var press_down: Vector2 = Vector2.ZERO
var press_release: Vector2 = Vector2.ZERO
var press_start_time: float = 0.0

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			pressed_down = true
			press_down = event.position
			press_start_time = Time.get_ticks_msec()
		elif event.is_released():
			pressed_down = false
			press_release = event.position
			var elapsed_msec = Time.get_ticks_msec() - press_start_time
			on_drag(press_down, press_release, elapsed_msec)
