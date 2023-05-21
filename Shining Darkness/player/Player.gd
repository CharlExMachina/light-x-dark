extends KinematicBody2D

signal on_hp_changed
signal on_destroyed

export(float) var movement_speed = 40.0

enum AttackMode {
	LIGHT_MODE
	DARK_MODE
}

onready var _ship_sprite = $PlayerShipSprite

var _velocity: Vector2
var _movement: Vector2
var _x_limits: float
var _sprite_size: float
var _can_shoot: bool = true
var _attack_mode = AttackMode.LIGHT_MODE

var x_acc = 0.0
var y_acc = 0.0

func _ready() -> void:
	_x_limits = get_viewport_rect().size.x
	var ship_sprite_frame_width = _ship_sprite.get_rect().size.x * _ship_sprite.transform.get_scale().x / 2.0
	_sprite_size = ship_sprite_frame_width


func _process(delta: float) -> void:
	_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _physics_process(delta: float) -> void:
	_handle_movement()
	_handle_mode_switch()

func _handle_movement() -> void:
	_velocity = _movement.normalized()
	_velocity = move_and_slide(_velocity * movement_speed)
	position.x = clamp(position.x, 0 + _sprite_size, _x_limits - _sprite_size)

func _handle_mode_switch() -> void:
	if (Input.is_action_just_pressed("light_mode_switch") and not _attack_mode == AttackMode.LIGHT_MODE):
		_attack_mode = AttackMode.LIGHT_MODE
		_ship_sprite.switch_to_light_mode()
	elif (Input.is_action_just_pressed("dark_mode_switch") and not _attack_mode == AttackMode.DARK_MODE):
		_attack_mode = AttackMode.DARK_MODE
		_ship_sprite.switch_to_dark_mode()
