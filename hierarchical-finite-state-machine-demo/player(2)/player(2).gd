extends CharacterBody2D


signal direction_changed(new_direction)
signal reconfigure(configuration_name: StringName)


var look_direction = Vector2.RIGHT:
	set(value):
		if value == look_direction or value == Vector2.ZERO:
			return
		look_direction = value
		direction_changed.emit(value)


func take_damage(attacker, amount, effect = null):
	if is_ancestor_of(attacker):
		$ActionPlayer/TakeDamage.play()
		return
	$States/Stagger.knockback_direction = (attacker.global_position - global_position).normalized()
	$Health.take_damage(amount, effect)
	$ActionPlayer/TakeDamage.play()

func set_dead(value):
	set_process_input(not value)
	set_physics_process(not value)
	$CollisionPolygon2D.disabled = value

func set_configuration(configuration_name: StringName) -> void:
	reconfigure.emit(configuration_name)
