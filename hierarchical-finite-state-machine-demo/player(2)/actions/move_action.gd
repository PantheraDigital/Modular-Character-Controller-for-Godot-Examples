extends ActionNode


@export var animation_player: AnimationPlayer
@export var character_physics: PhysicsStateMachine

@onready var _character: CharacterBody2D = _action_player.get_parent()


# _params = {"direction":vector2, run":bool}
func _on_play(_params: Dictionary = {}) -> void:
	var direction: Vector2 = _params[&"direction"].normalized()
	_character.look_direction = direction
	
	character_physics.active_state.move(_params)
	
	if character_physics.active_state is GroundMovement:
		animation_player.play("walk" if direction else "idle")
	else:
		animation_player.play("idle")

func _on_exit() -> void:
	character_physics.active_state.move({&"direction": Vector2.ZERO})

# ensure velocity is zero when move action is removed from action map
func _on_disable() -> void:
	_on_exit()
