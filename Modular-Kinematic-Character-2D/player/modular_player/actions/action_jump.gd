extends ActionNode


const JUMP_SPEED = 200

var _character: CharacterBody2D


func _ready() -> void:
	_character = _action_player.get_parent()
	play_action.connect(func(action:ActionNode): action._exit()) # exit action right after play


func _can_play() -> bool:
	return _character.is_on_floor()

func _on_play(_params: Dictionary = {}) -> void:
	_character.input_velocity.y = -JUMP_SPEED
