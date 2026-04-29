extends Resource
class_name InputRecord 

@export_storage var inputs: Dictionary[int, InputEvent] # {time_stamp:InputEvent}
@export_storage var global_delay: int # msec

func _to_string() -> String:
	var result: String = "{"
	for key: int in inputs.keys():
		var event: InputEventKey = inputs[key] as InputEventKey
		if event:
			result += str(key) + ":" + event.as_text() + ", "
		else:
			result += str(key) + ":" + type_string(typeof(inputs[key])) + ", "
	return result.rstrip(", ") + "}"
