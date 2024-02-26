extends Control
class_name MinigameCompleteUI

@onready var win_lose_label = $WinLoseLabel

func on_minigame_complete(status: Global.MinigameCompleteStatus):
	if status == Global.MinigameCompleteStatus.SUCCESS:
		win_lose_label.text = "WIN"
	else:
		win_lose_label.text = "LOSE"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
