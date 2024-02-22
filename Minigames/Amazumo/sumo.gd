extends RigidBody2D
class_name Sumo

static var sumo_scene_asset = preload("res://Minigames/Amazumo/sumo.tscn")

var is_player: bool = false
var cpu_difficulty: int = 1

static func create_player():
	var sumo = sumo_scene_asset.instantiate()
	sumo.is_player = true
	return sumo

static func create_cpu(difficulty: int = 1):
	var sumo = sumo_scene_asset.instantiate()
	sumo.is_player = false
	sumo.cpu_difficulty = difficulty
	return sumo

func get_sumo_sprite_size() -> Vector2:
	return $SumoSprite.texture.get_size()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.on_drag_signal.connect(on_drag)
	# at this point we should have already set up is_player before adding the sumo to the scene
	if not is_player:
		$SumoSprite.modulate = Color.RED

func on_drag(start: Vector2, end: Vector2, duration: float):
	if not is_player: return
	var drag_mag = (end - start).length()
	apply_central_impulse(end - start)

func cpu_lunge():
	# TODO: cache this...? who cares...
	var player: Sumo = null
	var cpu_parent = get_parent()
	for child in cpu_parent.get_children():
		if child is Sumo and child.is_player:
			player = child
	assert(player != null)
	var to_player: Vector2 = player.position - position
	print(to_player)
	var sprite_size = get_sumo_sprite_size().length()
	if to_player.length() < sprite_size:
		to_player += to_player.normalized() * sprite_size # <- arbitrary
	apply_central_impulse(to_player)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_cpu_lunge_timer_timeout():
	if is_player: return
	cpu_lunge()
