extends PathFollow2D

export(int) var health_points = 100
export(float) var movement_speed = 50.0
export(PackedScene) var beam_scene

var _should_follow_path: bool = true

func _process(delta: float) -> void:
	if _should_follow_path:
		offset += movement_speed * delta
