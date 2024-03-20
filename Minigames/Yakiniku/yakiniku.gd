extends Control

var meat_scene = preload("res://Minigames/Yakiniku/meat.tscn")
@onready var meat_container = $MeatContainer

func on_main_timer_timeout():
	print("custom timeout!")
	Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.TIMEOUT)

func get_transition_text():
	return "COOK\nTHE\nMEAT"

# Called when the node enters the scene tree for the first time.
func _ready():
	var meat_points = meat_container.get_children()
	for i in range(4):
		var meat_instance = meat_scene.instantiate()
		meat_instance.position = meat_points[i].position
		meat_instance.rotation = randf_range(-90, 90)
		meat_container.add_child(meat_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
