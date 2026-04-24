extends ActionNode


@export var animation_player: AnimationPlayer
@export var sword: Node
@export var bullet: Node

var old_map: Dictionary[StringName, NodePath]
@onready var attack_map: Dictionary[StringName, NodePath] = {&"attack": get_path()}


func _ready() -> void:
	sword.attack_finished.connect(_end)


# _params = {"type":"sword"/"bullet"}
func _on_play(_params: Dictionary = {}) -> void:
	if !_params.has(&"type"):
		return
	
	if _params[&"type"] == &"sword":
		if !is_playing and !old_map:
			old_map = _action_player.action_map
			_action_player.set_action_map(self, attack_map)
		
		animation_player.play("idle")
		sword.attack() 
		
	elif _params[&"type"] == &"bullet":
		bullet.fire()
		play_action.connect(func(_action): _exit(), CONNECT_ONE_SHOT) # queue stop at end of play


func _end() -> void:
	if old_map:
		_action_player.set_action_map(self, old_map)
		old_map = {}
		_exit()
