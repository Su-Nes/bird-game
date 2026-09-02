extends State

class_name FallState


@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../CameraPivotY"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

@export var WING_STATES : WingStateMachine
@export var GLIDE_SPEED = 4.5
@export var AIR_INERTIA = 2.5
@export var CAMERA_MOVEMENT : CameraRotation
@export var CAMERA_FOLLOW_STRENGTH = .05

var direction

func enter():
	print("Entered Fall state.")
	#WING_STATES.change_state("wingsgliding")
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func physics_update(delta: float):
	if Input.is_action_pressed("jump") and player_controller.velocity.y <= 0.0:
		state_machine.change_state("HoverState")
	
	if Input.is_action_just_pressed("jump") and player_controller.velocity.y > 0.0:
		state_machine.change_state("FlyState")
	
	# Add the gravity.
	if !player_controller.is_on_floor():
		player_controller.velocity.y -= gravity * delta
	else:
		state_machine.change_state("idlestate")
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (camera_pivot_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	handle_velocity(delta)
	
	CAMERA_MOVEMENT.look_towards_y(input_dir.x, CAMERA_FOLLOW_STRENGTH * delta * player_controller.velocity.normalized().length(), 0.0)
	
	
func handle_velocity(delta):	
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * GLIDE_SPEED, delta * AIR_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * GLIDE_SPEED, delta * AIR_INERTIA)
	
	player_controller.move_and_slide()
	
	extension_functions.handle_model_transform(direction)
	
