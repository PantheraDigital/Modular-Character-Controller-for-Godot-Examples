extends ActionNode

## Uses [MovementState] to move character in any direction, including up and down
## relative to the direction the camera is facing.
##
## This action plays when the character is using "FlyingMovement".
## When it is played it expects an "input_direction" to guide movement, 
## and allows for optional "alt_move" which simply adds the force with a different flag allowing 
## for two movements at once.
## It is designed to be played continuously till the character should stop and will 
## exit itself after play.


@export var speed: float = 3.0

@export var _movement_class: MovementState 
@export var _cam_control: CamControl



func _ready() -> void:
	play_action.connect(immediate_exit_self)


func _can_play() -> bool:
	if _movement_class and _cam_control:
		if _movement_class.enabled and _movement_class.name == &"FlyingMovement":
			return true
	return false

## [param _params] = {&"input_direction":[Vector3], &"alt_move":[bool]} \
## "alt_move" - optional, sets if velocity is applied as direct movement or indirect. (use to apply two movements at the same time)
func _on_play(_params: Dictionary = {}) -> void:
	if !_params.has(&"input_direction"):
		return 
	
	var dir: Vector3 = _params[&"input_direction"]
	if dir != Vector3.ZERO and !dir.is_equal_approx(Vector3.UP) and !dir.is_equal_approx(Vector3.DOWN):
		dir.y = (-_cam_control.camera.global_basis.z).y
	
	# align movement to cam forward
	dir = dir.rotated(Vector3.UP, _cam_control.rotation.y)
	
	if !_params.has(&"alt_move"):
		_movement_class.add_velocity(dir * speed, MovementState.Velocity_Tag.MOVE)
	else:
		_movement_class.add_velocity( dir * speed, (MovementState.Velocity_Tag.ALT_MOVE if _params[&"alt_move"] else MovementState.Velocity_Tag.MOVE) )
