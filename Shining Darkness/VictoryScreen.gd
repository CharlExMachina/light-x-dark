extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FinalScore.text = str(ScoreManager.get_score())
