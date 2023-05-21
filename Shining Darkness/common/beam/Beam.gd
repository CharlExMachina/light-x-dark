extends Area2D

export(int) var damage_value = 1
export(Vector2) var normalized_direction = Vector2(0, 0)
export(float) var movement_speed = 40.0

func _process(delta: float) -> void:
	global_translate(-transform.y * movement_speed * delta)
	pass

func _on_DisappearDelay_timeout():
	queue_free()
