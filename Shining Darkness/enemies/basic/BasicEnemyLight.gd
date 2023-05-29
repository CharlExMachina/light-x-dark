extends "res://enemies/BaseEnemy.gd"


func _on_TimeToShoot_timeout() -> void:
	var instanced_light_beam = beam_scene.instance()
	get_parent().add_child(instanced_light_beam)
	instanced_light_beam.global_position = global_position


func _on_Area2D_area_entered(area: Area2D) -> void:
	var damage = area.damage_value

	health_points -= damage

	if (health_points <= 0):
		ScoreManager.add_score(100)
		_should_follow_path = false
		$AnimatedSprite.hide()
		$Area2D.set_deferred("monitoring", false)
		$Area2D.set_deferred("monitorable", false)
		$TimeToShoot.stop()
		$ExplosionSound.play()
		$ExplosionAnimation.show()
		$ExplosionAnimation.play("default")
		_should_follow_path = false


func _on_ExplosionAnimation_animation_finished() -> void:
	queue_free()
