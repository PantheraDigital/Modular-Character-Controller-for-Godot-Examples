extends ActionNode

## Rotates the camera on the character.
##
## This action plays as long as it is enabled.
## When it is played it expects a rotation value to rotate the CamControl by, and will also 
## rotate the Array nodes.
## It is designed to be played continuously and will exit itself after play.


## The speed rotation should happen at. 0.0, no rotation. 0.1, slow. 1.0, instant.
@export_range(0.0, 1.0) var lerp_value: float = 0.15
@export var face_velocity: Array[Node3D]
@export var face_cam_forward: Array[Node3D]

@export var _cam_control: CamControl

@onready var _character: CharacterBody3D = _action_player.get_parent()



func _ready() -> void:
	play_action.connect(immediate_exit_self)

func _process(_delta: float) -> void:
	if face_velocity:
		for node: Node3D in face_velocity:
			StaticHelpers.face_point(node, _character.velocity, false, lerp_value)
	if face_cam_forward:
		for node: Node3D in face_cam_forward:
			StaticHelpers.face_point(node, -_cam_control.basis.z, false, lerp_value)


func _on_disable() -> void:
	_exit()

## [param _params] = {&"rotation": Vector2} \
## rotation is the amount to rotate and the direction. \
## Vector2(5,90): 5 deg right, 90 deg up
func _on_play(_params: Dictionary = {}) -> void:
	if !_params.has(&"rotation"):
		return
	
	_cam_control.rotate_xy(_params[&"rotation"])
