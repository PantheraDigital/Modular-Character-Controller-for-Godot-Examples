extends Node
class_name PhysicsStateMachine

@export var start_state: StringName
@export var states: Dictionary[StringName, PhysicsState]

var active_state: PhysicsState


func _ready() -> void:
	change_state(start_state)
	
	## trigger state change when character reconfigures 
	## state names correspond to configuration names
	get_parent().reconfigure.connect(change_state)

func change_state(state_name: StringName) -> void:
	if states.has(state_name):
		if active_state:
			active_state.exit()
		active_state = states[state_name]
		active_state.enter()
