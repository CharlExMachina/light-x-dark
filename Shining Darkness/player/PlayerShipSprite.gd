extends Sprite

export(Texture) var light_mode_sprite
export(Texture) var dark_mode_sprite

func switch_to_light_mode() -> void:
	texture = light_mode_sprite

func switch_to_dark_mode() -> void:
	texture = dark_mode_sprite
