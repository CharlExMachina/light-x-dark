extends Area2D

export(int) var damage_value = 1
export(float) var movement_speed = 40.0

func _process(delta: float) -> void:
	global_translate(-transform.y * movement_speed * delta)
	pass

func _on_DisappearDelay_timeout():
	queue_free()


func _on_EnemyDarkBeam_area_entered(area: Area2D) -> void:
	# check if player is in the dark collision layer
	var is_in_dark_mode = area.get_collision_mask_bit(2)

	if not is_in_dark_mode:
		# it only destroys itself if the player is in light mode
		queue_free()
