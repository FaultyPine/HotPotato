extends Control
class_name MainRoot
# Main will handle changing scenes (main menu -> first minigame -> next minigame)
# will also keep track of score, lives, etc



var lives = 3
var score = 0
var current_minigame_idx = 0
var is_main_menu = true

var current_minigame = null

var minigames = [
	preload("res://Minigames/Amazumo/Amazumo.tscn"),
]

@onready var main_menu = $MainMenu
@onready var minigame_container = $MinigameContainer
@onready var ingame_pause_menu = $MinigameContainer/IngamePause

# Called when the node enters the scene tree for the first time.
func _ready():
	show_main_menu()
	Global.on_ingame_pause_signal.connect(toggle_ingame_pause)
	
func toggle_ingame_pause():
	print("Pause toggle")
	get_tree().paused = not get_tree().paused
	var current_pause_state: bool = get_tree().paused
	ingame_pause_menu.visible = current_pause_state
	# make sure node have their ProcessMode set properly

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_next_minigame():
	if current_minigame_idx >= len(minigames):
		print("ran out of minigames")
		return
	# remove previous minigame and add new one
	if current_minigame != null:
		minigame_container.remove_child(current_minigame)
	current_minigame = minigames[current_minigame_idx].instantiate()
	minigame_container.add_child(current_minigame)
	current_minigame_idx += 1

func show_main_menu():
	is_main_menu = true
	main_menu.visible = true
	if current_minigame != null:
		current_minigame_idx = 0
		minigame_container.remove_child(current_minigame)
		current_minigame = null

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if is_main_menu:
				print("booting up first minigame")
				main_menu.visible = false
				# TODO: tutorial first?
				start_next_minigame()
				
