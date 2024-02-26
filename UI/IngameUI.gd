extends Control

@onready var timer_ui = $ColorRect/HBoxContainer/Timer
@onready var timer_ui_number = $ColorRect/HBoxContainer/Timer/TimeNumber
@onready var lives_container = $ColorRect/HBoxContainer/Lives

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_timer(timer: Timer):
	var percent = float(timer.time_left)/float(timer.wait_time)
	timer_ui.value = int(percent * 100)
	timer_ui_number.text = str(int(timer.time_left))

func update_lives(num_lives: int):
	var lives_sprites = lives_container.get_children()
	assert(len(lives_sprites) >= num_lives)
	for child in lives_sprites:
		var is_life_valid = num_lives > 0
		child.modulate.a = 1.0 if is_life_valid else 0.2
		num_lives -= 1

func _on_pause_button_pressed():
	Global.on_ingame_pause_signal.emit()

