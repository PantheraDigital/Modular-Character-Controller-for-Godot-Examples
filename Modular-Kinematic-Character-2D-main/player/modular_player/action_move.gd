extends ActionNode

const WALK_FORCE = 600

# optional variables. uncomment to include
# set by ActionManager when ActionManager enters tree or when ActionNode is added to ActionManager
var _character: CharacterBody2D
#var _manager: ActionManager
#var _container: ActionContainer


func _init() -> void:
	self.TYPE = &"move"

## _params: {"direction": float}
func _play(_params: Dictionary = {}) -> void:
	if !_params.has(&"direction"):
		return
	
	# turn input into velocity
	var walk = WALK_FORCE * _params[&"direction"]
	_character.input_velocity.x = walk
	super.__exit()
