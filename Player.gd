extends KinematicBody2D # everything that KinematicBody2D can do, this script extends and can do as well

var velocity = Vector2.ZERO
const MAX_SPEED = 100
const ACCELERATION = 10
const FRICTION = 10

# underscore -> callback function that runs at runtime
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength('ui_up') - Input.get_action_strength('ui_down')
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED) * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_collide(velocity)
