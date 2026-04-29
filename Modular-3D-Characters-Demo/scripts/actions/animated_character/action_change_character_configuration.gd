extends ActionNode

## Changes character configuration (state).
##
## This action plays if it is enabled.
## When it is played it will configure aspects of the character to a "state".
## It is designed to coordinate multiple parts of the character and exits itself after play.


@export var _movement_manager: MovementStateManager
@export var _remapper: ActionMapRemapper

var active_config: StringName = &"grounded"


func _ready() -> void:
	play_action.connect(immediate_exit_self)


## [param _params] = {&"config":&"grounded"/&"flying"/&"toggle"}
func _on_play(_params: Dictionary = {}) -> void:
	if !_params.has(&"config"):
		return 
	
	match _params[&"config"]:
		&"grounded", &"flying":
			set_config(_params[&"config"])
		&"toggle":
			if active_config == &"grounded":
				set_config(&"flying")
			elif active_config == &"flying":
				set_config(&"grounded")


func set_config(config: StringName) -> void:
	match config:
		&"grounded":
			active_config = &"grounded"
			_remapper.set_active_map(&"Grounded")
			_movement_manager.set_active_state(&"GroundedMovement")
		&"flying":
			active_config = &"flying"
			_remapper.set_active_map(&"Flying")
			_movement_manager.set_active_state(&"FlyingMovement")
