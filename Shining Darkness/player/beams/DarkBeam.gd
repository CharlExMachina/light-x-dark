extends "res://common/beam/Beam.gd"

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", 15.0, 0.03)
	tween.tween_property(self, "rotation_degrees", -15.0, 0.03)
	tween.set_loops(10)
