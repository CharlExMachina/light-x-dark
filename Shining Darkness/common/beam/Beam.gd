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
	var is_expecting_dark_beams = area.get_collision_mask_bit(2)
	var is_expecting_light_beams = area.get_collision_mask_bit(3)

	print("Light collision mask", is_expecting_dark_beams, "dark collision mask", is_expecting_dark_beams, " ", area.name)

	if is_expecting_dark_beams:
		# it only destroys itself if the player is in light mode
		queue_free()
