extends Controller
class_name DummyController


var input_record: InputRecord
var init_time: int # msec # time this was added to tree
var _dir: float


func _ready() -> void:
	if !input_record:
		set_process(false)
	init_time = Time.get_ticks_msec()

func _process(_delta: float) -> void:
	var delay: int = input_record.global_delay
	
	# check for inputs between last frame and now
	var to: int = Time.get_ticks_msec()
	var from: int = to - int(_delta * 1000)
	
	for msec: int in range(from, to):
		var adjusted_msec: int = (msec - init_time) + delay # apply starting offset
		if input_record.inputs.has(adjusted_msec):
			_handle_input(input_record.inputs[adjusted_msec])

func _handle_input(event: InputEvent) -> void:
	if !event.is_action(&"move_left") and !event.is_action(&"move_right") and !event.is_action(&"jump"):
		return
	
	if event.is_action_pressed(&"jump"):
		action_player.play(self, &"jump")
		return
	
	if event.is_action_pressed(&"move_left") or event.is_action_released(&"move_right"):
		_dir -= 1.0
	
	if event.is_action_pressed(&"move_right") or event.is_action_released(&"move_left"):
		_dir += 1.0
	
	if event.is_action_pressed(&"move_left") or event.is_action_pressed(&"move_right") \
	or event.is_action_released(&"move_left") or event.is_action_released(&"move_right"):
		if is_equal_approx(_dir, 0.0):
			action_player.stop(self, &"move")
		else:
			action_player.play(self, &"move", {&"direction":_dir} )
	
