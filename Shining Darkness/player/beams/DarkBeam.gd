extends "res://common/beam/Beam.gd"

func _ready() -> void:
	# horrible hack, pretty much _ready() is called before the
	# player sets the rotation to either 35 or -35,
	# so I have to wait .05 secs so this runs when
	# those values are set :p
	yield(get_tree().create_timer(0.05), "timeout")

	var tween = get_tree().create_tween()

	if rotation_degrees < 0:
		tween.tween_property(self, "rotation_degrees", -45, 0.03)
		tween.tween_property(self, "rotation_degrees", -30, 0.03)
	elif rotation_degrees > 0:
		tween.tween_property(self, "rotation_degrees", 45, 0.03)
		tween.tween_property(self, "rotation_degrees", 30, 0.03)
	else:
		tween.tween_property(self, "rotation_degrees", 15, 0.03)
		tween.tween_property(self, "rotation_degrees", -15, 0.03)

	tween.set_loops(100)


func _on_DarkBeam_area_entered(area: Area2D) -> void:
	if not area.get_collision_mask_bit(3):
		return

	movement_speed = 0.0
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	$Sprite.hide()
	$Sprite2.hide()
	$Sprite3.hide()
	$CollisionParticle.emitting = true
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
