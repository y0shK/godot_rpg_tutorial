extends KinematicBody2D # everything KinematicBody2D can do, this script imports

var velocity = Vector2.ZERO
const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

onready var animationPlayer = $AnimationPlayer # calls a path to the node in the same scene

# underscore -> callback function - runs at runtime
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# moving
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		#velocity += input_vector * ACCELERATION * delta
		#velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationPlayer.play("IdleRight")
	
	velocity = move_and_slide(velocity) # in real-time frames, apply move_and_slide info to the velocity
