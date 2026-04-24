extends Node2D

var bullet = preload("res://player/bullet/Bullet.tscn")


func fire():
	if not $CooldownTimer.is_stopped():
		return

	$CooldownTimer.start()
	var new_bullet = bullet.instantiate()
	add_child(new_bullet)
	new_bullet.position = global_position
	new_bullet.direction = owner.look_direction
