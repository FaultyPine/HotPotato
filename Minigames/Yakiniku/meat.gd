extends TextureRect
class_name Meat

enum CookStatus
{
	UNCOOKED,
	COOKED,
	BURNT
}

# two cook percents, one for each side of the meat
var cook_percent = [0,0] # [0, 1]
var current_side = 0
@export var cook_percent_per_tick = 0.002
@onready var smoke_particles = $SmokeParticles

var cooked_lower_bound = 1.0
var cooked_upper_bound = 1.8

# Called when the node enters the scene tree for the first time.
func _ready():
	cooked_lower_bound += randf_range(-0.1, 0.2)

func is_cooked(cook_percent: float):
	return cook_percent >= cooked_lower_bound and cook_percent <= cooked_upper_bound
func is_uncooked(cook_percent: float):
	return cook_percent < cooked_lower_bound
func is_burnt(cook_percent: float):
	return cook_percent > cooked_upper_bound

func get_cooked_status():
	var side1 = cook_percent[0]
	var side2 = cook_percent[1]
	# if either side is burnt or uncooked, the whole thing is bad
	if is_burnt(side1) or is_burnt(side2):
		return CookStatus.BURNT
	if is_uncooked(side1) or is_uncooked(side2):
		return CookStatus.UNCOOKED
	if is_cooked(side1) and is_cooked(side2):
		return CookStatus.COOKED
	print("COOK STATUS FALLBACK - THIS SHOULDNT HAPPEN!")
	return CookStatus.UNCOOKED # fallback... shouldn't ever get here

func update_cooked_aesthetics(cook_percent: float):
	smoke_particles.modulate.a = cook_percent
	if is_burnt(cook_percent):
		modulate = Color(0.1, 0.1, 0.1)
	elif is_cooked(cook_percent):
		var brown = Color(140.0/255.0, 100.0/255.0, 0)
		modulate = brown
	else:
		modulate = Color.WHITE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cook_percent[current_side] += cook_percent_per_tick
	var current_cook = cook_percent[current_side]
	if is_burnt(current_cook):
		# player has burnt some side of some meat
		var msg = tr("YAKINIKU_FAILURE_BURNT")
		Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.FAILURE, msg)
	update_cooked_aesthetics(current_cook)
	
func flip():
	current_side = 1 - current_side

func _on_gui_input(event):
	if event is InputEventScreenTouch and event.is_pressed():
		flip()
