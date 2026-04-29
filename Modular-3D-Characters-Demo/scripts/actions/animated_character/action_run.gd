extends ActionNode

## Increases the movement speed of _move_action when it plays
## by adjusting the walk_speed before it plays.
##
## This action plays if it is enabled.
## When it is played it will modify the walk_speed variable in move action every play call
## by using signals. 
## It is designed to be called continuously till the character should stop running and will 
## exit itself after a short period of not being called to play.


@export var _move_action: ActionGroundedMove

# self exits after not being played for a time
var _timer: Timer
var _exit_delay_sec: float = 0.1 


func _ready() -> void:
	# final clean up delay
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_exit)


func _can_play() -> bool:
	return _move_action != null

func _on_enter() -> void:
	if !_move_action.enter_action.is_connected(_speed_boost):
		_move_action.enter_action.connect(_speed_boost)

func _on_play(_params: Dictionary = {}) -> void:
	_timer.start(_exit_delay_sec)

func _on_exit() -> void:
	if _move_action.enter_action.is_connected(_speed_boost):
		_move_action.enter_action.disconnect(_speed_boost)


func _speed_boost(action: ActionNode) -> void:
	if action == _move_action:
		_move_action.walk_speed += 1.0
