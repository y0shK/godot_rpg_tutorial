extends KinematicBody2D # everything KinematicBody2D can do, this script imports

var velocity = Vector2.ZERO

enum {
	MOVE, # 0
	ROLL, # 1
	ATTACK # 2
}
var state = MOVE

const MAX_SPEED = 80
const ACCELERATION = 500
const FRICTION = 500

onready var animationPlayer = $AnimationPlayer
#var animationPlayer = null
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	# animationPlayer var is a reference to the node of the same scene
	#animationPlayer = $AnimationPlayer # path to a node in the same scene
	animationTree.active = true

# underscore -> callback function - runs at runtime
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength('ui_left')
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# just keep animationTree during movement, remembers motion direction when stopping
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		#velocity += input_vector * ACCELERATION * delta
		#velocity = velocity.clamped(MAX_SPEED)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		#animationPlayer.play("IdleRight")
	
	#move_and_collide(velocity * delta)
	velocity = move_and_slide(velocity) # in real-time frames, apply move_and_slide info to the velocity

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack_state(delta):
	# set velocity vector to zero to not 'remember' momentum after attack; no sliding
	velocity = Vector2.ZERO
	animationState.travel('Attack')

func attack_animation_finished():
	state = MOVE # when attack animation finishes, go back to move state
