extends Controller

## Provides input from player to [ActionManager] on a character. \
## Example of player controller.

# Expected input list:
# move_left, move_right, move_forwards, move_backwards
# fly_up, fly_down
# run, jump, dash


const DOUBLE_TAP_DELAY: float = 0.25


var _last_input_window: float = 0.0
var _last_input: StringName

var _double_tap_running: bool


func _on_controlled_obj_change():
	var _cam_control: Node3D = controlled_obj.get_node("CamPivot")
	if _cam_control.camera:
		_cam_control.camera.make_current()


func _process(delta: float) -> void:
	if _last_input_window > 0.0:
		_last_input_window -= delta
		if _last_input_window <= 0.0:
			_last_input = &""
	
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	var input: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_forwards", &"move_backwards")
	if input:
		action_player.play( self, &"move", {&"input_direction":Vector3(input.x, 0.0, input.y)} )
	
	if Input.is_action_pressed(&"run"):
		action_player.play( self, &"run" )
	
	if Input.is_action_pressed(&"fly_up"):
		action_player.play( self, &"move", {&"input_direction":Vector3.UP, &"alt_move":true} )
	
	if Input.is_action_pressed(&"fly_down"):
		action_player.play( self, &"move", {&"input_direction":Vector3.DOWN, &"alt_move":true} )


func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		action_player.play( self, &"look", {&"rotation":event.relative} )
		return
	
	if event.is_action(&"jump") and event.is_action_pressed(&"jump"):
		if double_tap_check(&"jump"):
			action_player.play( self, &"change_config", {&"config":&"toggle"} )
		else:
			action_player.play( self, &"jump" )
	
	if event.is_action(&"dash"):
		if event.is_action_pressed(&"dash"):
			action_player.play( self, &"dash" )
	
	if event.is_action(&"move_forwards"):
		if event.is_action_pressed(&"move_forwards") and double_tap_check(&"move_forwards"):
			action_player.play( self, &"run" )
			_double_tap_running = true
		if event.is_action_released(&"move_forwards") and _double_tap_running:
			action_player.stop( self, &"run" )
			_double_tap_running = false
	


## If input was pressed twice quickly
func double_tap_check(input: StringName) -> bool:
	var result := false
	if _last_input == &"":
		_last_input = input
		_last_input_window = DOUBLE_TAP_DELAY
	elif _last_input == input:
		result = true
		_last_input = &""
		_last_input_window = 0.0
	return result
