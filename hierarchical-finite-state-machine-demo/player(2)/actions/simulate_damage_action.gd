extends ActionNode

# this action calls the damage system on character since it simulates damage
# action (simulate damage) -> character (take damage) -> action (respond to damage)
#
# normally the damage system may call an action
# but actions are not required for a damage system

func _ready() -> void:
	play_action.connect(func(action:ActionNode): action._exit())

func _can_play() -> bool:
	return true

func _on_play(_params: Dictionary = {}) -> void:
	_action_player.owner.take_damage(self, 1)
