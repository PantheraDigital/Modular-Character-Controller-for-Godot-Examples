extends Controller


var input_record: InputRecord # {time_stamp:InputEvent}


func _ready() -> void:
	input_record = InputRecord.new()
	input_record.global_delay = Time.get_ticks_msec()

# Be mindful of how many requests are made
func _process(_delta: float) -> void:
	var input = Input.get_axis(&"move_left", &"move_right")
	if Input.is_action_just_pressed(&"move_left") or Input.is_action_just_pressed(&"move_right") \
	or Input.is_action_just_released(&"move_left") or Input.is_action_just_released(&"move_right"):
		if is_equal_approx(input, 0.0):
			action_player.stop(self, &"move")
		else:
			action_player.play(self, &"move", {&"direction":input} )
	
	if Input.is_action_just_pressed(&"jump"):
		action_player.play(self, &"jump")


func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	
	# record only used inputs for dummy
	if event.is_action(&"jump") or event.is_action(&"move_left") or event.is_action(&"move_right"):
		input_record.inputs[Time.get_ticks_msec()] = event
