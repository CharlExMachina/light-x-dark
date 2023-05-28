extends "res://enemies/BaseEnemy.gd"

var _should_return := false


func _process(delta: float) -> void:
	if _should_follow_path:
		offset += movement_speed * delta
		if unit_offset >= 0.97:
			_should_follow_path = false
			$TimeToShoot.start()
			$TimeToStopShooting.start()
	elif _should_return:
		offset -= movement_speed * delta
		if unit_offset <= 0.03:
			queue_free()


func _on_TimeToShoot_timeout() -> void:
	var beam_instance_center = beam_scene.instance()
	var beam_instance_left = beam_scene.instance()
	var beam_instance_right = beam_scene.instance()

	get_parent().add_child(beam_instance_center)
	get_parent().add_child(beam_instance_left)
	get_parent().add_child(beam_instance_right)

	beam_instance_center.global_position = global_position
	beam_instance_left.global_position = global_position
	beam_instance_right.global_position = global_position

	beam_instance_center.rotation_degrees = rotation_degrees - 90
	beam_instance_left.rotation_degrees = rotation_degrees - 90 - 35.0
	beam_instance_right.rotation_degrees = rotation_degrees - 90 + 35.0


func _on_TimeToStopShooting_timeout() -> void:
	$TimeToShoot.stop()
	_should_return = true



func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_bit(2):
		return

	var damage = area.damage_value

	health_points -= damage

	if (health_points <= 0):
		_should_follow_path = false
		$AnimatedSprite.hide()
		$Area2D.set_deferred("monitoring", false)
		$Area2D.set_deferred("monitorable", false)
		$TimeToShoot.stop()
		$ExplosionAnimation.show()
		$ExplosionAnimation.play("default")


func _on_ExplosionAnimation_animation_finished() -> void:
	queue_free()
