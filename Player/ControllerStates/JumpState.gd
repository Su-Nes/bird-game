extends State

class_name JumpState


var isJumping
var jumpCounter
var direction

@export var JUMP_VELOCITY = 3
@export var JUMP_TIME = .12
@export var JUMP_GRAVITY = 27

@export var MOVE_SPEED = 4
@export var AIR_INERTIA = 2.5

@onready var player_controller: CharacterBody3D = $"../.."
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

func enter():
	#print("Entered Jump state")
	player_controller.velocity.y = JUMP_VELOCITY
	
	isJumping = true
	jumpCounter = 0.0
		
	#jump_audio.play()
		
func physics_update(delta: float):
	# Handle dynamic jumping
	if player_controller.velocity.y > 0.0 and isJumping:
		jumpCounter += delta
		player_controller.velocity.y += JUMP_GRAVITY * delta
		
	# If stopped jumping switch to fall state
	if Input.is_action_just_released("jump") or jumpCounter > JUMP_TIME:
		isJumping = false
		state_machine.change_state("fallstate")

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (player_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	handle_velocity(delta)

func handle_velocity(delta):
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * MOVE_SPEED, delta * AIR_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * MOVE_SPEED, delta * AIR_INERTIA)
	
	player_controller.move_and_slide()
	
	extension_functions.handle_model_transform(direction)
