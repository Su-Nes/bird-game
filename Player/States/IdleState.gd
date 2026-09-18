extends State

class_name IdleState


@export var WING_STATES : WingStateMachine
@export var CAMERA_SCRIPT : CameraMovement
@export var CAMERA_POSITION : Vector3 = Vector3(.3, .6, 0)
@export var CAMERA_DISTANCE : float = 1
@export var CAMERA_MOVE_LERP : float = .15

@onready var camera_pivot_y: Node3D = $"../../CameraControl/CameraPivotY"
@onready var player_controller: CharacterBody3D = $"../.."
@onready var walk_state: WalkState = $"../WalkState"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

var direction


func enter():
	WING_STATES.change_state("wingsidle")
	CAMERA_SCRIPT.move_cam(CAMERA_DISTANCE, CAMERA_POSITION, CAMERA_MOVE_LERP)
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func physics_update(delta):	
	# Switch to fall state if player controller is not on ground.
	if !player_controller.is_on_floor():
		state_machine.change_state("fallstate")
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (camera_pivot_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction.length() > 0.0:
		state_machine.change_state("walkstate")
		
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
	
	handle_velocity(delta)
	
func handle_velocity(delta):	
	player_controller.velocity.x = lerp(player_controller.velocity.x, 0.0, delta * walk_state.GROUND_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, 0.0, delta * walk_state.GROUND_INERTIA)
	
	player_controller.move_and_slide()
	
	extension_functions.handle_model_transform(direction, player_controller.get_floor_normal())
	extension_functions.rotate_to_floor_normal()
