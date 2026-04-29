extends ActionNode


const WALK_FORCE = 600

var _character: CharacterBody2D


func _ready() -> void:
	_character = _action_player.get_parent()


## _params: {"direction": float}
func _on_play(_params: Dictionary = {}) -> void:
	if !_params.has(&"direction"):
		return
	
	# turn input into velocity
	var walk = WALK_FORCE * _params[&"direction"]
	_character.input_velocity.x = walk

func _on_stop() -> void:
	_character.input_velocity.x = 0.0
