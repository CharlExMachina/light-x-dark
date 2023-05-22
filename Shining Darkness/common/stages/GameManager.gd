extends Node

onready var health_bar = get_node("%HealthBar") as TextureProgress

func _on_Player_on_hp_changed(hp, max_hp) -> void:
	print(hp, " ", max_hp, " ", hp / max_hp)
	health_bar.value = (hp / max_hp) * 100.0
