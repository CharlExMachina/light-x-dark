extends Node

onready var _health_bar = get_node("%HealthBar") as TextureProgress
onready var _spawner = get_node("%Spawner")


func _ready() -> void:
	var children = _spawner.get_children()

	for enemy_round in children:
		var current_round = enemy_round as EnemyRound
		yield(get_tree().create_timer(current_round.spawn_delay_in_seconds), "timeout")

		for enemy_scene in current_round.enemy_units_to_spawn:
			var instanced_enemy = enemy_scene.instance()
			current_round.get_unit_path().add_child(instanced_enemy)
			yield(get_tree().create_timer(current_round.time_between_spawns), "timeout")


func _on_Player_on_hp_changed(hp, max_hp) -> void:
	_health_bar.value = (hp / max_hp) * 100.0
	$Camera2D.add_trauma(0.4)
	$CanvasLayer/ColorRect.damage()
