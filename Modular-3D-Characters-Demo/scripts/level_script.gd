extends Node3D

## Swaps Player controller with AI controller

@export var player_controller: Controller
@export var ai_controller: Controller



func _process(_delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if !player_controller and !ai_controller:
		return
	
	var player_character: Node3D = player_controller.controlled_obj
	var ai_character: Node3D = ai_controller.controlled_obj
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB:
			player_controller.controlled_obj = ai_character
			ai_controller.controlled_obj = player_character
