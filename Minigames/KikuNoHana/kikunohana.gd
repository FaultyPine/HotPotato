extends Control

@onready var cupsContainer = $CupsContainer
@onready var cupSpots = $CupSpots
@onready var flower = $Flower

@onready var whereIsFlowerText = $WhereIsFlowerText
@onready var tapTheCupText = $TapTheCupText

var are_cups_done_moving = true
var num_shuffles = -1
const max_num_shuffles = 3

func get_transition_text():
	return "FOLLOW\nTHE\nFLOWER"

func cups_done_moving():
	whereIsFlowerText.visible = true
	tapTheCupText.visible = true
	are_cups_done_moving = true
	for cup in cupsContainer.get_children():
		cup.can_be_picked = true

var t = 0.0
func put_flower_under_cup():
	var cups = cupsContainer.get_children()
	var idx = randi_range(0, len(cups)-1)
	var selected_cup = cups[idx]
	selected_cup.has_flower = true
	var tween = get_tree().create_tween()
	tween.tween_property(flower, "position", selected_cup.position, 0.5)
	await(tween.finished)
	flower.reparent(selected_cup, true)
	flower.visible = false
	return tween.finished



func cup_to_spot(cup, spot: Vector2, spotIdx: int):
	var cupPos = cup.position
	cup.set_tween_dest(spot, spotIdx, max(max_num_shuffles - num_shuffles, 1))

func move_cups():
	are_cups_done_moving = false
	var spots = cupSpots.get_children()
	randomize()
	spots.shuffle()
	var cups = cupsContainer.get_children()
	# cups[i] should move to spots[i]	
	for i in range(len(spots)):
		cup_to_spot(cups[i], spots[i].position, i)
	
func num_cups_done_moving():
	var cups = cupsContainer.get_children()
	var num = 0
	for cup in cups:
		if cup.is_finished_tween():
			num += 1
	return num
	
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	num_shuffles = -1
	are_cups_done_moving = true
	var cups = cupsContainer.get_children()
	var spots = cupSpots.get_children()
	assert(len(cups) == len(spots))
	for i in range(len(cups)):
		cups[i].position = spots[i].position
	await get_tree().create_timer(0.8).timeout
	await(put_flower_under_cup())
	await get_tree().create_timer(0.2).timeout
	move_cups()
	
func _process(delta):
	if num_shuffles < 0:
		num_shuffles = randi_range(1, max_num_shuffles)
	if not are_cups_done_moving and num_cups_done_moving() >= cupsContainer.get_child_count():
		if num_shuffles > 0:
			num_shuffles -= 1
			move_cups()
		else:
			cups_done_moving()

func on_end():
	for cup in cupsContainer.get_children():
		cup.set_cup_opacity(0.1)
	flower.visible = true
	flower.modulate.a = 1.0
	
