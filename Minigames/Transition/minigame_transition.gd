extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_transition(minigame_root, duration_seconds):
	assert(minigame_root.has_method("get_transition_text"))
	var text = minigame_root.get_transition_text()
	visible = true
	$GamePrompt.text = text
	get_tree().paused = true
	await(get_tree().create_timer(duration_seconds).timeout)
	get_tree().paused = false
	visible = false
	
