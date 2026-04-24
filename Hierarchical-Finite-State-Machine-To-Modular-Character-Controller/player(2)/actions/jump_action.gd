extends ActionNode


@export var animation_player: AnimationPlayer
@export var physics_machine: PhysicsStateMachine
@export var gravity: float = 1600.0

@onready var _character: CharacterBody2D = _action_player.get_parent()

var vertical_speed = 0.0
var height = 0.0


func _on_disable() -> void:
	set_physics_process(false)

func _on_enable() -> void:
	set_physics_process(true)


func _can_play() -> bool:
	return !is_playing

func _on_enter() -> void:
	set_physics_process(true)
	animation_player.play(&"idle")
	_character.set_configuration(&"Air")
	vertical_speed = 600.0

func _on_exit() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	animate_jump_height(delta)
	if height <= 0.0:
		_character.set_configuration(&"Ground")
		super._exit()


func animate_jump_height(delta):
	vertical_speed -= gravity * delta
	height += vertical_speed * delta
	height = max(0.0, height)
	
	_character.get_node(^"BodyPivot").position.y = -height
