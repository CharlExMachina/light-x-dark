extends KinematicBody2D

signal on_hp_changed
signal on_destroyed

export(float) var movement_speed = 40.0
export(float) var hp = 100.0

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
var _y_limits: float
var _sprite_size: float
var _can_shoot_light_beam: bool = true
var _can_shoot_dark_beam: bool = true
var _attack_mode = AttackMode.LIGHT_MODE
var _max_hp = hp
var _is_dead := false

var x_acc = 0.0
var y_acc = 0.0

func _ready() -> void:
	_x_limits = get_viewport_rect().size.x
	_y_limits = get_viewport_rect().size.y
	var ship_sprite_frame_width = _ship_sprite.get_rect().size.x * _ship_sprite.transform.get_scale().x / 2.0
	_sprite_size = ship_sprite_frame_width

	# light mode default
	_set_light_mode_hitbox()


func _process(delta: float) -> void:
	if _is_dead:
		return

	_movement = Input.get_vector("move_left", "move_right", "move_up", "move_down")


func _physics_process(delta: float) -> void:
	if _is_dead:
		return

	_handle_movement()
	_handle_mode_switch()

	if Input.is_action_pressed("shoot"):
		_shoot_beam()


func _handle_movement() -> void:
	_velocity = _movement.normalized()
	_velocity = move_and_slide(_velocity * movement_speed)
	position.x = clamp(position.x, 0 + _sprite_size, _x_limits - _sprite_size)
	position.y = clamp(position.y, 0 + _sprite_size, _y_limits - _sprite_size)


func _handle_mode_switch() -> void:
	if (Input.is_action_just_pressed("light_mode_switch") and not _attack_mode == AttackMode.LIGHT_MODE):
		_attack_mode = AttackMode.LIGHT_MODE
		_ship_sprite.switch_to_light_mode()
		_set_light_mode_hitbox()
	elif (Input.is_action_just_pressed("dark_mode_switch") and not _attack_mode == AttackMode.DARK_MODE):
		_attack_mode = AttackMode.DARK_MODE
		_ship_sprite.switch_to_dark_mode()
		_set_dark_mode_hitbox()


func _set_light_mode_hitbox() -> void:
	_hitbox.set_collision_mask_bit(4, true) # enables collision with dark beams
	_hitbox.set_collision_mask_bit(5, false) # disables collision with light beams


func _set_dark_mode_hitbox() -> void:
	_hitbox.set_collision_mask_bit(5, true) # enables collision with light beams
	_hitbox.set_collision_mask_bit(4, false) # disables collision with dark beams


func _shoot_beam() -> void:
	if _is_dead:
		return

	if _can_shoot_light_beam and _attack_mode == AttackMode.LIGHT_MODE:
		_can_shoot_light_beam = false
		var beam_instance = _light_beam_scene.instance()
		get_parent().add_child(beam_instance)
		beam_instance.position = position - Vector2(0, 20)
		_light_beam_timer.start()
	elif _can_shoot_dark_beam and _attack_mode == AttackMode.DARK_MODE:
		_can_shoot_dark_beam = false

		var beam_instance_center = _dark_beam_scene.instance()
		var beam_instance_left = _dark_beam_scene.instance()
		var beam_instance_right = _dark_beam_scene.instance()

		get_parent().add_child(beam_instance_center)
		get_parent().add_child(beam_instance_left)
		get_parent().add_child(beam_instance_right)

		beam_instance_center.position = position - Vector2(0, 20)
		beam_instance_left.position = position - Vector2(10, 20)
		beam_instance_right.position = position - Vector2(-10, 20)

		beam_instance_left.rotation_degrees = -35.0
		beam_instance_right.rotation_degrees = 35.0

		_dark_beam_timer.start()


func _on_LightBeamDelay_timeout() -> void:
	_can_shoot_light_beam = true


func _on_DarkBeamDelay_timeout() -> void:
	_can_shoot_dark_beam = true


func _on_Hitbox_area_entered(area: Area2D) -> void:
	# It's late at night and I'm half asleep, don't ask me how it works...
	# just accept the fact that it does work
	if _attack_mode == AttackMode.LIGHT_MODE:
		if get_collision_mask_bit(5) == area.get_collision_layer_bit(5):
			return

	if _attack_mode == AttackMode.DARK_MODE:
		if get_collision_mask_bit(4) == area.get_collision_layer_bit(4):
			return

	var damage = area.damage_value
	hp -= damage
	emit_signal("on_hp_changed", hp, _max_hp)

	if hp <= 0:
		$PlayerShipSprite.hide()
		$Explosion.play("default")
		_is_dead = true
		emit_signal("on_destroyed")
