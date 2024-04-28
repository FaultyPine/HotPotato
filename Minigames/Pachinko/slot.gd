extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_ball_enter_slot():
	Global.on_ingame_minigame_over_signal.emit(Global.MinigameCompleteStatus.SUCCESS)

func _on_body_entered(body):
	if body.name.contains("Ball"):
		on_ball_enter_slot()
