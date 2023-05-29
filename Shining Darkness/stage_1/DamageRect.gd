extends ColorRect

func damage() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(self, "color", Color(0.5, 0.0, 0.0, 0.4), 0.2)
	tween.tween_property(self, "color", Color(0.0, 0.0, 0.0, 0.0), 0.2)
	tween.play()
