extends ActionNode

## Applies upward velocity to character.
##
## This action plays when the character is on the floor and this action is not playing.
## When it is played it will add a vertival impulse force to the character.
## It is designed to be played once per button push and will exit itself after play.


const JUMP_STRENGTH: float = 5.0

@export var _movement_class: MovementState 

@onready var _character: CharacterBody3D = _action_player.get_parent()


func _can_play() -> bool:
	if _movement_class:
		return _character.is_on_floor() and is_playing == false
	return false

func _on_play(_params: Dictionary = {}) -> void:
	_movement_class.add_velocity(Vector3.UP * JUMP_STRENGTH, MovementState.Velocity_Tag.JUMP)
	play_action.connect(immediate_exit_self, CONNECT_ONE_SHOT)
