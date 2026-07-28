extends State

class_name WalkState


@export var MOVE_SPEED: float
@export var GROUND_INERTIA = 14.0
@export var MOMENTUM_DECAY = 1.0
@export var CAMERA_MOVEMENT : CameraRotation
@export var CAMERA_AUTO_LOOK_LERP = .05
var coyoteTimer

@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../CameraPivotY"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

var direction
var velocity

func enter():
	#print("Entered Walk state")
	pass
	
func physics_update(delta):
	# Switch to fall state if player controller is not on ground.
	if !player_controller.is_on_floor():
		state_machine.change_state("fallstate")
	
	# Switch to jump state	
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
		return
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (camera_pivot_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	handle_velocity(delta)
	
	CAMERA_MOVEMENT.look_towards(direction, CAMERA_AUTO_LOOK_LERP)
	
	# Switch to idle when no movement direction is held.
	if direction.length() <= 0.0:
		state_machine.change_state("idlestate")

func handle_velocity(delta):
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * MOVE_SPEED, delta * GROUND_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * MOVE_SPEED, delta * GROUND_INERTIA)
	
	player_controller.move_and_slide()
	
	extension_functions.handle_model_transform(direction)
