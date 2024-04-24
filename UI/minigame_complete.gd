extends Control
class_name MinigameCompleteUI

@onready var win_lose_label = $WinLoseLabel

func on_minigame_complete(status: Global.MinigameCompleteStatus, msg: String):
	if len(msg) > 0:
		win_lose_label.text = msg
	else:
		if status == Global.MinigameCompleteStatus.SUCCESS:
			win_lose_label.text = tr("WIN")
		else:
			win_lose_label.text = tr("LOSE")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
