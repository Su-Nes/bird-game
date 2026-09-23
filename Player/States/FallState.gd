extends State

class_name FallState


@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../CameraControl/CameraPivotY"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

@export var WING_STATES : WingStateMachine
@export_range(0, 1) var FALL_ANGLE_MOD : float = .3
@export var MINIMUM_FLIGHT_VELOCITY : float = 2
@export var FLIGHT_V_MULTIPLIER : float = 20
@export var HOVER_SPEED : float = 4.5
@export var AIR_INERTIA : float = 2.5
@export var CAMERA_MOVEMENT : CameraMovement
@export var CAMERA_FOLLOW_STRENGTH = .05

var direction
var flight_timer

func enter():
	WING_STATES.change_state("wingsgliding")
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func update(delta: float):
	if Input.is_action_pressed("jump") and player_controller.velocity.length() < MINIMUM_FLIGHT_VELOCITY and player_controller.velocity.y <= 0.0 or Input.is_action_pressed("break"):
		state_machine.change_state("HoverState")
		return
	
	if Input.is_action_just_pressed("jump"):
		if player_controller.velocity.y > 0:
			player_controller.velocity = player_controller.velocity.rotated(extension_functions.MESH.global_basis.x, deg_to_rad(3)) * FLIGHT_V_MULTIPLIER
		state_machine.change_state("FlyState")
		return
	
	# Add the gravity.
	if !player_controller.is_on_floor():
		var flat_cam_forward = CAMERA_MOVEMENT.get_camera_forward()
		flat_cam_forward.y = 0
		player_controller.velocity += flat_cam_forward * gravity * FALL_ANGLE_MOD * delta
		player_controller.velocity.y -= gravity * (1 - FALL_ANGLE_MOD) * delta
	else:
		state_machine.change_state("idlestate")
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (camera_pivot_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	handle_velocity(delta)
	
	CAMERA_MOVEMENT.look_towards_y(input_dir.x, CAMERA_FOLLOW_STRENGTH * delta * player_controller.velocity.normalized().length(), 0.0)
	
	
func handle_velocity(delta):	
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * HOVER_SPEED, delta * AIR_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * HOVER_SPEED, delta * AIR_INERTIA)
	
	player_controller.move_and_slide()
	
	var look_at_flat = player_controller.velocity
	look_at_flat.y = 0
	extension_functions.handle_model_transform(look_at_flat, Vector3.UP, .05)
