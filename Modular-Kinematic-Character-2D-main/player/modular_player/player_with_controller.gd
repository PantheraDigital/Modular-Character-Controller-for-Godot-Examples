extends CharacterBody2D

# Controller -> Action Manager -> Action -> CharacterBody2D

const MAX_SPEED = 200
const STOP_FORCE = 1300

# variable for external control
var input_velocity: Vector2

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	
	# Slow down the player if they're not trying to move.
	if is_equal_approx(input_velocity.x, 0.0):
		# The velocity, slowed down a bit, and then reassigned.
		velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
	else:
		velocity.x += input_velocity.x * delta
	
	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	move_and_slide()

	if !is_equal_approx(input_velocity.y, 0.0):
		velocity.y = input_velocity.y
		input_velocity.y = 0
