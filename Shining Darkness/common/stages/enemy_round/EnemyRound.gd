extends Node
class_name EnemyRound

export(float) var spawn_delay_in_seconds
export(float) var time_between_spawns
export(Array, PackedScene) var enemy_units_to_spawn

func get_unit_path() -> Path2D:
	return $Path2D as Path2D
