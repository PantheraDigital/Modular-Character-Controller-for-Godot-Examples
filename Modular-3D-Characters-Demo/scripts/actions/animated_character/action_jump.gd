extends ActionNode

## Sends character up by applying upward force.
##
## This action plays when it is not already playing and when the character is on the floor.
## When it is played it applies a vertical impulse force to the character 
## and sets a variable in the animation tree to trigger the jump anim.
## It is designed to be played once per button push and will exit itself shortly after play,
## using a short delay to ensure the animation tree variable had time to register the change.


const JUMP_STRENGTH: float = 5.0

@export var _movement_class: MovementState
@export var _anim_tree: AnimationTree

@onready var _character: CharacterBody3D = _action_player.get_parent()



func _ready() -> void:
	play_action.connect(delayed_exit_self)


func _can_play() -> bool:
	if _movement_class and _character.is_on_floor():
		return is_playing == false
	return false

func _on_play(_params: Dictionary = {}) -> void:
	_movement_class.add_velocity(Vector3.UP * JUMP_STRENGTH, MovementState.Velocity_Tag.JUMP)
	
	if _anim_tree:
		_anim_tree.jump = true

func _on_exit() -> void:
	if _anim_tree:
		_anim_tree.jump = false
