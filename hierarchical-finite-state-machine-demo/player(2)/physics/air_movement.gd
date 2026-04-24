extends PhysicsState
class_name AirMovement


@export var base_max_horizontal_speed: float = 400.0

@export var air_acceleration: float = 1000.0
@export var air_deceleration: float = 2000.0
@export var air_steering_power: float = 50.0

@export var character: CharacterBody2D

var max_horizontal_speed: float = 0.0
var enter_velocity: Vector2
var _direction: Vector2


func enter() -> void:
	super.enter()
	enter_velocity = character.velocity
	if character.velocity:
		max_horizontal_speed = character.velocity.length()
	else:
		max_horizontal_speed = base_max_horizontal_speed

func move(_params: Dictionary = {}) -> void:
	_direction = _params[&"direction"].normalized() if _params.has(&"direction") else Vector2.ZERO


func _physics_process(delta: float) -> void:
	var target_velocity: Vector2
	if _direction:
		target_velocity = character.velocity.move_toward((_direction * max_horizontal_speed), (air_acceleration * delta))
	else:
		target_velocity = character.velocity.move_toward(Vector2.ZERO, (air_deceleration * delta))
	target_velocity = (target_velocity - character.velocity).normalized() * air_steering_power
	
	character.velocity += target_velocity
	character.move_and_slide()
