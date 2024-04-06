extends Control

var meat_scene = preload("res://Minigames/Yakiniku/meat.tscn")
@onready var meat_container = $MeatContainer

func on_main_timer_timeout():
	print("custom timeout!")
	Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.TIMEOUT)

func get_minigame_time():
	return 15.0

func get_transition_text():
	return "COOK BOTH SIDES\nOF THE\nMEAT\n\nTAP TO FLIP"

var num_meat = 4 # should be the same as the number of MeatPoint nodes in the MeatContainer

func _ready():
	var meat_points = meat_container.get_children()
	for i in range(num_meat):
		var meat_instance = meat_scene.instantiate()
		meat_instance.position = meat_points[i].position
		meat_instance.rotation = randf_range(-90, 90)
		meat_container.add_child(meat_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# if all meat is cooked, win
	var num_cooked = 0
	var meat_points = meat_container.get_children()
	for meat in meat_points:
		if meat.name.contains("MeatPoint"): continue
		if meat.get_cooked_status() == Meat.CookStatus.COOKED:
			num_cooked += 1
	if num_cooked >= num_meat:
		Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.SUCCESS)
