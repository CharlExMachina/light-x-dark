extends PathFollow2D

# NOTE:
# Repeating code like this is NOT a good practice. The reason I'm doing it for this project
# is because I'm running out of time, and I want to actually finish it in time for the jam

export(int) var health_points = 10
export(float) var movement_speed = 50.0

var _is_dead := false


func _process(delta: float) -> void:
	if _is_dead:
		return

	offset += movement_speed * delta
	if unit_offset >= 1.0 and not _is_dead:
		$Trail.emitting = false
		$SmallParticles.emitting = false


func _die() -> void:
	ScoreManager.add_score(800)
	_is_dead = true
	$Trail.emitting = false
	$SmallParticles.emitting = false
	$AnimatedSprite.hide()
	$ExplosionSound.play()
	$ExplosionAnimation.show()
	$ExplosionAnimation.play("default")
	$Area2D.set_deferred("monitoring", false)
	$Area2D.set_deferred("monitorable", false)


func _on_TimeToDisappear_timeout() -> void:
	queue_free()


func _on_Area2D_area_entered(area: Area2D) -> void:
	# first, check if its colliding with the player character
	var is_in_player_layer = area.get_collision_layer_bit(0)

	if is_in_player_layer:
		var is_in_dark_mode = area.get_collision_mask_bit(5)

		if not is_in_dark_mode:
			_die()
	else:
		var damage = area.damage_value

		health_points -= damage

		if (health_points <= 0):
			_die()


func _on_ExplosionAnimation_animation_finished() -> void:
	$ExplosionAnimation.playing = false
	$ExplosionAnimation.visible = false
	yield(get_tree().create_timer(2.0), "timeout")
	queue_free()
