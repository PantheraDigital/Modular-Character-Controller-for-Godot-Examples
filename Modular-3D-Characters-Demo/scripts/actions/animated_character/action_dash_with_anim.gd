extends ActionNode

## Dash action plays animation with rootmotion. 
## Commands from animation signal mapping changes for dynamic action control through the animation.
##
## This action plays when it is not already playing and when the character is on the floor.
## When it is played it will play an animation that uses root motion to move the character,
## changes the action map of the character based on signals from the animation,
## and allows specific actions to interrupt this action by exiting this action before they play.
## It is designed to be called once per button push and will exit itself after the animation is done, 
## resetting the action map to what it was when this action was first entered.


@export var _movement_class: MovementState
@export var _anim_tree: AnimationTree
@export var _collider_anim_player: AnimationPlayer

@onready var _character: CharacterBody3D = _action_player.get_parent()
@onready var _dash_map: Dictionary[StringName, NodePath] = {&"dash":get_path(), &"look":^"Look"}

var _old_map: Dictionary[StringName, NodePath]
var _collider_is_shrunk: bool 
var _interupting_actions: Array[ActionNode]



func _ready() -> void:
	_anim_tree.animation_finished.connect(
		func(anim_name:StringName):
			if is_playing and anim_name == &"Locomotion/Slide":
				super._exit()
	)
	_anim_tree.animation_command.connect(_on_animation_command)
	
	_collider_anim_player.animation_started.connect(
		func(anim_name:StringName):
			if anim_name == &"shrink":
				_collider_is_shrunk = true
			elif anim_name == &"grow":
				_collider_is_shrunk = false
	)


func _can_play() -> bool:
	return !is_playing and _character.is_on_floor()

func _on_enter() -> void:
	_old_map = _action_player.action_map
	_action_player.set_action_map(self, _dash_map)
	_anim_tree.play(&"Locomotion/Slide")

func _on_stop() -> void:
	_anim_tree.fade_out()
	if _collider_is_shrunk:
		_collider_anim_player.play(&"grow")

func _on_exit() -> void:
	_action_player.set_action_map(self, _old_map)
	_old_map = {}
	_movement_class.use_root_motion = false # ensure set false after action is over
	
	if _interupting_actions and _interupting_actions.size() > 0:
		for action: ActionNode in _interupting_actions:
			if action.going_to_play_action.is_connected(immediate_stop_self):
				action.going_to_play_action.disconnect(immediate_stop_self)
		_interupting_actions = []


func _on_animation_command(animation: StringName, command: StringName) -> void:
	if animation != &"Slide" or !is_playing:
		return
	match command:
		&"dash_collision_default":
			_dash_map = {&"dash":get_path(), &"look":^"Look"}
			_action_player.set_action_map(self, _dash_map)
			
		&"dash_collision_allow_move":
			var move_path: NodePath = ^"Move"
			_action_player.set_request(self, &"move", move_path)
			
			var actions:Dictionary[NodePath, ActionNode] = _action_player.get_actions_dict()
			if actions.has(move_path):
				_interupting_actions.push_back(actions[move_path])
				actions[move_path].going_to_play_action.connect(immediate_stop_self)
			
		&"dash_collision_allow_jump":
			var jump_path: NodePath = ^"Jump"
			_action_player.set_request(self, &"jump", jump_path)
			
			var actions:Dictionary[NodePath, ActionNode] = _action_player.get_actions_dict()
			if actions.has(jump_path):
				_interupting_actions.push_back(actions[jump_path])
				actions[jump_path].going_to_play_action.connect(immediate_stop_self)
