extends TextureRect

enum CookStatus
{
	UNCOOKED,
	COOKED,
	BURNT
}

# two cook percents, one for each side of the meat
var cook_percent = [0,0] # [0, 1]
var current_side = 0
@export var cook_percent_per_tick = 0.001
@onready var smoke_particles = $SmokeParticles

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_cooked_aesthetics(cook_percent: float):
	smoke_particles.modulate.a = cook_percent
	var brown = Color(140.0/255.0, 100.0/255.0, 0)
	if cook_percent <= 1.0:
		modulate = Color(1.0, 1.0, 1.0).lerp(brown, cook_percent)
	else:
		modulate = brown.lerp(Color(0.0, 0.0, 0.0), cook_percent-1.0)

const cooked_lower_bound = 0.9
const cooked_upper_bound = 1.1
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cook_percent[current_side] += cook_percent_per_tick
	var current_cook = cook_percent[current_side]
	update_cooked_aesthetics(current_cook)
	
