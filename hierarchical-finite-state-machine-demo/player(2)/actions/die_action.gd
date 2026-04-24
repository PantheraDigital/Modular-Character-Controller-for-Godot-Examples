extends ActionNode


@export var animation_player: AnimationPlayer


func _can_play() -> bool:
	return true

func _on_enter() -> void:
	_action_player.get_parent().set_dead(true)
	animation_player.play("die")

func _on_play(_params: Dictionary = {}) -> void:
	super._exit()
