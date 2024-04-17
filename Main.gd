extends Control
class_name MainRoot
# Main will handle changing scenes (main menu -> first minigame -> next minigame)
# will also keep track of score, lives, etc



var current_player_idx = 0
var num_players = 1
var lives = []
const starting_num_lives = 3
var score = 0
var current_minigame_idx = 0
var is_main_menu = true

var current_minigame = null


const minigames = [
	preload("res://Minigames/KikuNoHana/kikunohana.tscn"),
	preload("res://Minigames/Chosoku/chosoku.tscn"),
	preload("res://Minigames/Pachinko/pachinko.tscn"),
	preload("res://Minigames/Yakiniku/yakiniku.tscn"),
	preload("res://Minigames/Amazumo/Amazumo.tscn"),
]

@onready var main_menu = $MainMenu
@onready var minigame_container = $MinigameContainer
@onready var ingame_pause_menu = $IngamePause
@onready var ingame_ui = $IngameUI
@onready var minigame_transition = $MinigameTransition
@onready var minigame_timer = $MinigameContainer/MinigameTimer
@onready var minigame_complete_ui: MinigameCompleteUI = $MinigameComplete

func get_current_minigame():
	return current_minigame

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(num_players): lives.append(starting_num_lives)
	show_main_menu()
	Global.on_ingame_pause_signal.connect(toggle_ingame_pause)
	Global.on_ingame_minigame_over_signal.connect(on_minigame_over)
	
func on_minigame_over(status: Global.MinigameCompleteStatus, msg: String = ""):
	var success = status == Global.MinigameCompleteStatus.SUCCESS
	if not success:
		decrement_player_life(current_player_idx)
	minigame_complete_ui.visible = true
	minigame_complete_ui.on_minigame_complete(status, msg)
	get_tree().paused = true
	await get_tree().create_timer(2.0).timeout
	get_tree().paused = false
	minigame_complete_ui.visible = false	
	start_next_minigame()
	
func decrement_player_life(player_idx):
	assert(player_idx >= 0 and player_idx < num_players)
	lives[player_idx] -= 1
	ingame_ui.update_lives(lives[player_idx])
	
func toggle_ingame_pause():
	# make sure node have their ProcessMode set properly
	get_tree().paused = not get_tree().paused
	var current_pause_state: bool = get_tree().paused
	ingame_pause_menu.visible = current_pause_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ingame_ui.update_timer(minigame_timer)

func set_minigame_timer(minigame_duration_sec: int):
	minigame_timer.paused = false
	minigame_timer.one_shot = true
	minigame_timer.start(minigame_duration_sec)

func start_next_minigame():
	if current_minigame_idx >= len(minigames):
		print("ran out of minigames")
		show_main_menu() # TEMP. If we've exhausted all minigames, what to do?
		return
	# remove previous minigame and add new one
	if current_minigame != null:
		minigame_container.remove_child(current_minigame)
	current_minigame = minigames[current_minigame_idx].instantiate()
	minigame_timer.paused = true
	await(minigame_transition.show_transition(current_minigame, 2.5))
	minigame_timer.paused = false	
	minigame_container.add_child(current_minigame)
	current_minigame_idx += 1
	ingame_ui.visible = true
	minigame_complete_ui.visible = false
	is_main_menu = false
	get_tree().paused = false
	var minigame_time = 10
	if current_minigame.has_method("get_minigame_time"):
		minigame_time = current_minigame.get_minigame_time()
	set_minigame_timer(minigame_time)

func show_main_menu():
	is_main_menu = true
	main_menu.visible = true
	ingame_ui.visible = false
	minigame_complete_ui.visible = false	
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
				

func _on_minigame_timer_timeout():
	# minigames can optionally handle their timeout behavior themselves
	if current_minigame.has_method("on_main_timer_timeout"):
		current_minigame.on_main_timer_timeout()
	else:
		Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.TIMEOUT)
