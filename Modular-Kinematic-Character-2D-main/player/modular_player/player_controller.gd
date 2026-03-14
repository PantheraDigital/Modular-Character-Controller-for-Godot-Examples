extends Controller


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var input = Input.get_axis(&"move_left", &"move_right")
	_action_manager.play_action( &"move", {&"direction":input} )
	
	if Input.is_action_just_pressed(&"jump"):
		_action_manager.play_action(&"jump")
