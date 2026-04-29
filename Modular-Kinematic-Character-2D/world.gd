extends Node2D


@export var player_spawn: Node2D
@export var player_controller: Node

var player: Node2D
var save_path: String = "user://input_records.tres"
var character_res: Resource = preload("res://player/modular_player/player_with_controller.tscn")


func _ready():
	player_controller.set_process(false)
	var add_player: Callable = func():
		player = character_res.instantiate()
		player.position = player_spawn.position
		add_child(player)
		player_controller.controlled_obj = player
		player_controller.set_process(true)
	
	if ResourceLoader.exists(save_path):
		var timer: SceneTreeTimer
		var temp = ResourceLoader.load(save_path, "InputRecords", ResourceLoader.CACHE_MODE_IGNORE)
		var input_records: InputRecords = temp as InputRecords
		
		var delay: int = 0 # msec
		for record: InputRecord in input_records.input_records:
			timer = get_tree().create_timer(delay * 0.001)
			timer.timeout.connect(_add_dummy.bind(record))
			delay += 500
		
		timer = get_tree().create_timer(delay * 0.001)
		timer.timeout.connect(add_player)
		
		timer = get_tree().create_timer((delay + 510) * 0.001)
		timer.timeout.connect(func(): print())
	else:
		add_player.call()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_backspace"):
		_on_reload()


# save player inputs 
func _on_reload() -> void:
	var player_inputs: InputRecord = player_controller.input_record
	var input_records: InputRecords = ResourceLoader.load(save_path, "InputRecords", ResourceLoader.CACHE_MODE_IGNORE) \
		if ResourceLoader.exists(save_path) else InputRecords.new()
	
	input_records.input_records.append(player_inputs)
	var error_code: int = ResourceSaver.save(input_records, save_path)
	if error_code != OK:
		print("save error code - ", error_string(error_code))
	
	get_tree().reload_current_scene()


# delete input records on game close
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_CRASH:
		if FileAccess.file_exists(save_path):
			print("delete - ",
			error_string(DirAccess.remove_absolute(save_path)))
		get_tree().quit() # default behavior


func _add_dummy(record: InputRecord) -> void:
	var dummy_character: Node2D = character_res.instantiate()
	dummy_character.position = player_spawn.position
	add_child(dummy_character)
	
	var dummy_controller: DummyController = DummyController.new()
	dummy_controller.input_record = record
	dummy_controller.controlled_obj = dummy_character
	add_child(dummy_controller)
	print("add dummy - ", dummy_character, " | controller ", dummy_controller, " | inputs - ", str(record))
