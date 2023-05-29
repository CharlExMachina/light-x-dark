extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	yield(get_tree().create_timer(3.0),"timeout")
	get_tree().change_scene("res://MainMenu.tscn")
