extends Controller


var run: bool


func _process(_delta: float) -> void:
	var input_direction: Vector2 = Vector2(
		Input.get_axis(&"move_left", &"move_right"),
		Input.get_axis(&"move_up", &"move_down")
	)
	action_player.play(self, &"move", {&"direction":input_direction, &"run":Input.is_action_pressed(&"run")})

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"jump"):
		action_player.play(self, &"jump")
	
	if event.is_action(&"run"):
		run = event.is_action_pressed(&"run")
	
	if event.is_action_pressed(&"fire"):
		action_player.play(self, &"attack", {&"type":&"bullet"})
	if event.is_action_pressed(&"attack"):
		action_player.play(self, &"attack", {&"type":&"sword"})
	if event.is_action_pressed(&"simulate_damage"):
		action_player.play(self, &"simulate_damage")
