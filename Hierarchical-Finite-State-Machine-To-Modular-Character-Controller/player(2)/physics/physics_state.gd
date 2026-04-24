extends Node
class_name PhysicsState


func _ready() -> void:
	exit()

func enter() -> void:
	set_physics_process(true)

func exit() -> void:
	set_physics_process(false)

func move(_params: Dictionary = {}) -> void:
	pass
