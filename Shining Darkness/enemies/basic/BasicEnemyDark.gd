extends "res://enemies/BaseEnemy.gd"


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_bit(3):
		return

	var damage = area.damage_value

	print(health_points)

	health_points -= damage

	if (health_points <= 0):
		$AnimatedSprite.hide()
		$Area2D.set_deferred("monitoring", false)
		$Area2D.set_deferred("monitorable", false)
		$TimeToShoot.stop()
		$ExplosionAnimation.play("default")


func _on_TimeToShoot_timeout() -> void:
	pass # Replace with function body.


func _on_ExplosionAnimation_animation_finished() -> void:
	queue_free()
