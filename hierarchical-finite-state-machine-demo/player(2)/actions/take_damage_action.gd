extends ActionNode


@export var animation_player: AnimationPlayer
var old_map: Dictionary[StringName, NodePath]


func _ready() -> void:
	enable()
	animation_player.animation_finished.connect(_on_animation_finished)

func _exit_tree() -> void:
	animation_player.animation_finished.disconnect(_on_animation_finished)


func _can_play() -> bool:
	return !is_playing

func _on_enter() -> void:
	animation_player.play(&"stagger") # anim getting overridden by other actions
	old_map = _action_player.action_map
	_action_player.set_action_map(self, {})


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"stagger":
		_action_player.set_action_map(self, old_map)
		super._exit()
