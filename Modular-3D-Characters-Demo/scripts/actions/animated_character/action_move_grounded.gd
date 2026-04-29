extends ActionNode
class_name ActionGroundedMove

## Uses [MovementState] to move character along the ground \
##   relative to the direction the camera is facing. \
## Speed can be adjusted. \
## Plays animations.
##
## This action plays when the character is using "GroundedMovement".
## When it is played it expects an "input_direction" to guide movement with an x and z value
## and will accelerate the chacter to the direction. It will also set a variable in the 
## anim tree to scale movement with the walk_speed.
## It is designed to be played continuously till the character should stop, it will exit itself after play, 
## and allows for external adjustment of walk_speed, which will need to be changed per play call.


@export var max_walk_speed: float = 3.0
@export var acceleration: float = 0.1

@export var _movement_class: MovementGroundedWithAnim 
@export var _cam_control: CamControl
@export var _anim_tree: AnimationTree

var walk_speed: float = 0.0
var _current_speed: float = 0.0
var _timer: Timer
var _clean_up_delay_sec: float = 0.1 


func _ready() -> void:
	play_action.connect(immediate_exit_self) # exit after play
	_movement_class.landed.connect(func(value: int): 
		if value > 0: 
			_final_clean_up()
			_timer.stop())
	
	# final clean up delay
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	
	exit_action.connect(_start_timer) # reset timer on action exit
	_timer.timeout.connect(_final_clean_up)

func _process(_delta: float) -> void:
	if _anim_tree and !is_playing:
		_anim_tree.idle_to_run_scale = 0.0


func _on_disable() -> void:
	_timer.stop() # stop final clean up timer when disabled to preserve _current_speed

func _can_play() -> bool:
	if _movement_class and _cam_control and _anim_tree:
		if _movement_class.enabled and _movement_class.name == &"GroundedMovement":
			return true
	return false

## _params[&"input_direction"] == normalized direction to move (local space, normalized)
func _on_play(_params: Dictionary = {}) -> void:
	if !_params.has(&"input_direction"):
		return
	
	# remove upward movement
	var dir: Vector3 = _params[&"input_direction"]
	dir.y = 0.0
	if !dir.is_normalized():
		dir = dir.normalized()
	
	if dir.is_equal_approx(Vector3.ZERO):
		return
	
	# align movement to cam forward
	dir = dir.rotated(Vector3.UP, _cam_control.rotation.y)
	
	walk_speed += max_walk_speed
	_current_speed = move_toward(_current_speed, walk_speed, acceleration)
	
	_movement_class.add_velocity(dir * _current_speed, MovementState.Velocity_Tag.MOVE)
	
	if _anim_tree:
		if is_equal_approx(walk_speed, max_walk_speed):
			_anim_tree.idle_to_run_scale = lerpf(0.0, 0.5, (_current_speed / walk_speed))
		elif is_equal_approx(walk_speed, 0.0):
			_anim_tree.idle_to_run_scale = 0.0
		else:
			_anim_tree.idle_to_run_scale = lerpf(0.0, 1.0, (_current_speed / walk_speed))
	
	# reset _walk_speed to 0.0 allows for adjusting speed externally each play call
	walk_speed = 0.0


func _start_timer(_action: ActionNode) -> void:
	if is_enabled:
		_timer.start(_clean_up_delay_sec)

func _final_clean_up() -> void:
	_current_speed = 0.0
