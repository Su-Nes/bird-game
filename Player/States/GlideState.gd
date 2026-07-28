extends State

class_name GlideState


@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../CameraPivotY"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

@export var WING_STATES : WingStateMachine
@export var GRAVITY_MOD : float
@export var GLIDE_SPEED = 4.5
@export var GLIDE_INERTIA = 2.5
@export var CAMERA_MOVEMENT : CameraRotation
@export var CAMERA_FOLLOW_STRENGTH = .05

var direction

func enter():
	print("Entered Glide state.")
	
	WING_STATES.change_state("WingsGliding")
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func physics_update(delta: float):
	# Add the gravity.
	if !player_controller.is_on_floor():
		player_controller.velocity.y -= gravity * delta * GRAVITY_MOD
	else:
		state_machine.change_state("idlestate")
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (camera_pivot_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	handle_velocity(delta)
	
	CAMERA_MOVEMENT.look_towards_y(input_dir.x, CAMERA_FOLLOW_STRENGTH * delta * player_controller.velocity.normalized().length())
	
	
func handle_velocity(delta):	
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * GLIDE_SPEED, delta * GLIDE_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * GLIDE_SPEED, delta * GLIDE_INERTIA)
	
	player_controller.move_and_slide()
	
	extension_functions.handle_model_transform(player_controller.velocity)
	
