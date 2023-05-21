extends KinematicBody2D

signal on_hp_changed
signal on_destroyed

export(float) var movement_speed = 40.0

var _velocity: Vector2
var _movement: Vector2
var _x_limits: float
var _sprite_size: float
var _can_shoot: bool = true

var x_acc = 0.0
var y_acc = 0.0


func _ready() -> void:
	_x_limits = get_viewport_rect().size.x
	var ship_sprite_frame_width = $Sprite.get_rect().size.x / 2
	_sprite_size = ship_sprite_frame_width


func _process(delta: float) -> void:
	_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _physics_process(delta: float) -> void:
	_velocity = _movement.normalized()

	_velocity = move_and_slide(_velocity * movement_speed)

	position.x = clamp(position.x, 0 + _sprite_size, _x_limits - _sprite_size)
