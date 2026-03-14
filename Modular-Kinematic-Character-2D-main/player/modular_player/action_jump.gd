extends ActionNode

const JUMP_SPEED = 200
# optional variables. uncomment to include
# set by ActionManager when ActionManager enters tree or when ActionNode is added to ActionManager
var _character: CharacterBody2D
#var _manager: ActionManager
#var _container: ActionContainer


func _init() -> void:
	self.TYPE = &"jump"


func _can_play() -> bool:
	return _character.is_on_floor()


func _play(_params: Dictionary = {}) -> void:
	_character.input_velocity.y = -JUMP_SPEED
	super.__exit()
