extends PhysicsState
class_name GroundMovement


@export var character: CharacterBody2D

@export var max_walk_speed: float = 450
@export var max_run_speed: float = 700

var _velocity: Vector2 = Vector2.ZERO


func move(_params: Dictionary = {}) -> void:
	var direction: Vector2 = _params[&"direction"].normalized() if _params.has(&"direction") else Vector2.ZERO
	var run: bool = _params[&"run"] if _params.has(&"run") else false
	
	_velocity = direction * (max_run_speed if run else max_walk_speed)


func _physics_process(_delta: float) -> void:
	character.velocity = _velocity
	character.move_and_slide()
