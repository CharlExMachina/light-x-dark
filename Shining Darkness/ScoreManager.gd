extends Node

signal on_scored_points

var _score := 0

func add_score(value) -> void:
	_score += value
	emit_signal("on_scored_points")

func get_score() -> int:
	return _score

func reset() -> void:
	_score = 0
