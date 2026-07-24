extends State

class_name WalkState

@export var MOVE_SPEED: float
@export var GROUND_INERTIA = 14.0
@export var AIR_INERTIA = 2.5
@export var MOMENTUM_DECAY = 1.0

@onready var player_controller: CharacterBody3D = $"../.."

var direction
var speed
var momentum = 0.0
var velocity

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func enter():
	print("Entered Walk state")

func physics_update(delta):
	# Add the gravity.
	if not player_controller.is_on_floor():
		player_controller.velocity.y -= gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (player_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	speed = MOVE_SPEED + momentum
	
	handle_velocity(delta)
	
	# Decrease momentum
	momentum = lerp(momentum, 0.0, delta * MOMENTUM_DECAY)
	if direction.length() <= 0.0:
		momentum = 0.0
		state_machine.change_state("idlestate")
		
	player_controller.move_and_slide()

func handle_velocity(delta):
	print(player_controller.velocity.length())
	#if player_controller.velocity.length() <= 0:
		#return
	
	if player_controller.is_on_floor():
		player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * speed, delta * GROUND_INERTIA)
		player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * speed, delta * GROUND_INERTIA)
	else:
		player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * speed, delta * AIR_INERTIA)
		player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * speed, delta * AIR_INERTIA)
	
	player_controller.move_and_slide()
