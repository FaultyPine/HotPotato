extends Node2D


@onready var sumo_ring = $SumoRing
var is_complete = false

func get_transition_text():
	return "STAY IN\nTHE RING\n\nPUSH THE\nOPPONENT OUT"

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: show brief gesture/prompt screen before starting
	start_sumo()

func start_sumo():
	# one sumo for player, one for cpu
	var player_sumo = Sumo.create_player()
	add_child(player_sumo)
	var cpu_sumo = 	Sumo.create_cpu()
	add_child(cpu_sumo)
	# start them spaced out a bit
	var player_sumo_sprite_height = player_sumo.get_sumo_sprite_size().y
	var cpu_sumo_sprite_height = cpu_sumo.get_sumo_sprite_size().y
	var player_start_pos = sumo_ring.position + (Vector2.UP * player_sumo_sprite_height)
	var cpu_start_pos = sumo_ring.position + (Vector2.DOWN * cpu_sumo_sprite_height)
	player_sumo.position = player_start_pos
	cpu_sumo.position = cpu_start_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_player_lost():
	Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.FAILURE)
	
	
func on_player_won():
	Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.SUCCESS)

func _on_area_2d_body_exited(body):
	# annoying hack. area_exit is called when destroying the scene. 
	# Need to make sure this isn't called when we quit to main menu or switch to new minigame
	if Global.get_main_root().is_main_menu: return 
	if body is Sumo and not is_complete:
		is_complete = true
		if body.is_player:
			on_player_lost()
		else:
			on_player_won()

