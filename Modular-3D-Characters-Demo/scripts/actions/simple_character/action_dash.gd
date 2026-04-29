extends ActionNode

## Applies a burst of velocity for a short time on character \
##   forward relative to the direction of its collision shape.
## Uses custom [ActionCollision] to block movement while this action is playing.
##
## This action plays based on a cooldown timer.
## When it is played it adds a continuous force to the character for a short time, 
## and changes the action map of the character to limit which actions can be done while this action plays.
## It is designed to be called once per button push and will exit itself when done,
## reseting the action map to what it was when this action was first entered.



const COOLDOWN: float = 0.5
const PLAYTIME: float = 0.25
const SPEED: float = 10.0

@export var _movement_class: MovementState 
@export var _collision_shape_3d: CollisionShape3D

var _cooldown_countdown: float = 0.0
var _playtime_countdown: float = 0.0

var _old_map: Dictionary[StringName, NodePath]
@onready var _dash_map: Dictionary[StringName, NodePath] = {&"dash":get_path(), &"look":^"Look", &"jump":^"Jump"}


func _process(delta: float) -> void:
	if _cooldown_countdown > 0.0:
		_cooldown_countdown -= delta
	
	if _playtime_countdown > 0.0:
		_playtime_countdown -= delta
		
		var forward: Vector3 = -_collision_shape_3d.basis.z
		_movement_class.add_velocity(forward * SPEED, MovementState.Velocity_Tag.MOVE)
		
	elif is_playing:
		super._exit()


func _can_play() -> bool:
	return _cooldown_countdown <= 0.0

func _on_enter() -> void:
	_cooldown_countdown = COOLDOWN
	_playtime_countdown = PLAYTIME
	_old_map = _action_player.action_map
	_action_player.set_action_map(self, _dash_map)

func _on_exit() -> void:
	_action_player.set_action_map(self, _old_map)
	_old_map = {}
