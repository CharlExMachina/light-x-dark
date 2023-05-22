extends KinematicBody2D

signal on_hp_changed
signal on_destroyed

export(float) var movement_speed = 40.0

enum AttackMode {
	LIGHT_MODE
	DARK_MODE
}

onready var _ship_sprite = $PlayerShipSprite
onready var _dark_beam_timer = $DarkBeamDelay
onready var _light_beam_timer = $LightBeamDelay
onready var _hitbox = $Hitbox

var _light_beam_scene = preload("res://player/beams/LightBeam.tscn")
var _dark_beam_scene = preload("res://player/beams/DarkBeam.tscn")

var _velocity: Vector2
var _movement: Vector2
var _x_limits: float
var _sprite_size: float
var _can_shoot_light_beam: bool = true
var _can_shoot_dark_beam: bool = true
var _attack_mode = AttackMode.LIGHT_MODE

var x_acc = 0.0
var y_acc = 0.0

func _ready() -> void:
	_x_limits = get_viewport_rect().size.x
	var ship_sprite_frame_width = _ship_sprite.get_rect().size.x * _ship_sprite.transform.get_scale().x / 2.0
	_sprite_size = ship_sprite_frame_width

	# light mode default
	set_collision_mask_bit(3, true) # enables collision with dark beams
	set_collision_mask_bit(2, false) # disables collision with light beams


func _process(delta: float) -> void:
	_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _physics_process(delta: float) -> void:
	_handle_movement()
	_handle_mode_switch()

	if Input.is_action_pressed("shoot"):
		_shoot_beam()


func _handle_movement() -> void:
	_velocity = _movement.normalized()
	_velocity = move_and_slide(_velocity * movement_speed)
	position.x = clamp(position.x, 0 + _sprite_size, _x_limits - _sprite_size)


func _handle_mode_switch() -> void:
	if (Input.is_action_just_pressed("light_mode_switch") and not _attack_mode == AttackMode.LIGHT_MODE):
		_attack_mode = AttackMode.LIGHT_MODE
		_ship_sprite.switch_to_light_mode()
		set_collision_mask_bit(3, true) # enables collision with dark beams
		set_collision_mask_bit(2, false) # disables collision with light beams
	elif (Input.is_action_just_pressed("dark_mode_switch") and not _attack_mode == AttackMode.DARK_MODE):
		_attack_mode = AttackMode.DARK_MODE
		_ship_sprite.switch_to_dark_mode()
		set_collision_mask_bit(2, true) # enables collision with light beams
		set_collision_mask_bit(3, false) # disables collision with dark beams


func _shoot_beam() -> void:
	if _can_shoot_light_beam and _attack_mode == AttackMode.LIGHT_MODE:
		_can_shoot_light_beam = false
		var beam_instance = _light_beam_scene.instance()
		get_parent().add_child(beam_instance)
		beam_instance.position = position - Vector2(0, 20)
		_light_beam_timer.start()
	elif _can_shoot_dark_beam and _attack_mode == AttackMode.DARK_MODE:
		_can_shoot_dark_beam = false
		var beam_instance = _dark_beam_scene.instance()
		get_parent().add_child(beam_instance)
		beam_instance.position = position - Vector2(0, 20)
		_dark_beam_timer.start()


func _on_LightBeamDelay_timeout() -> void:
	_can_shoot_light_beam = true


func _on_DarkBeamDelay_timeout() -> void:
	_can_shoot_dark_beam = true
