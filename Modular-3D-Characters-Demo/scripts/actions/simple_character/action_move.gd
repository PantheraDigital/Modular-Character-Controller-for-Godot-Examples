extends ActionNode

## Apply velocity to the character based on camera direction.
##
## This action plays when the character is using "GroundedMovement".
## When it is played it expects an "input_direction" with z and x values to direct the movement.
## It is designed to be played continuously till the character should stop
## and will exit itself after play.


@export var walk_speed: float = 3.0

@export var _movement_class: MovementState 
@export var _cam_control: CamControl


func _can_play() -> bool:
	if _movement_class and _cam_control:
		if _movement_class.enabled and _movement_class.name == &"GroundedMovement":
			return true
	return false

## _params[&"input_direction"] == normalized direction to move. local space.
func _on_play(_params: Dictionary = {}) -> void:
	if !_params.has(&"input_direction"):
		return
	
	# remove upward movement
	var dir: Vector3 = _params[&"input_direction"]
	dir.y = 0.0
	if !dir.is_normalized():
		dir = dir.normalized()
	
	if dir.is_equal_approx(Vector3.ZERO):
		play_action.connect(immediate_exit_self, CONNECT_ONE_SHOT)
		return
	
	# align movement to cam forward
	dir = dir.rotated(Vector3.UP, _cam_control.rotation.y)
	
	_movement_class.add_velocity(dir * walk_speed, MovementState.Velocity_Tag.MOVE)
	play_action.connect(immediate_exit_self, CONNECT_ONE_SHOT)
