extends Controller

## Provides input to [ActionManager] on a character. \
## Example of a very basic ai controller.



func _process(_delta: float) -> void:
	# walk in circle by adding forward movement and a constant 5 degree horizontile rotation to direction faced. 
	action_player.play(self, &"move", {&"input_direction":Vector3.FORWARD})
	action_player.play(self, &"look", {&"rotation":Vector2(5.0, 0.0)})
