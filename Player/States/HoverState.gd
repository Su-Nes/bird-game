extends State

class_name HoverState


@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../CameraControl/CameraPivotY"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

@export var WING_STATES : WingStateMachine
@export_category("Parameters")
@export var HOVER_SPEED : float = 4.5
@export var HOVER_INERTIA : float = 2.5
@export var FLIGHT_TRANSITION_VELOCITY : float = 10
@export var TIME_FOR_DOUBLE_TAP_FLY : float = .1
var fly_timer : float
@export_category("Camera")
@export var CAMERA_MOVEMENT : CameraMovement
@export var CAMERA_FOLLOW_STRENGTH : float = .05
@export var CAMERA_POSITION : Vector3 = Vector3(.3, .6, 0)
@export var CAMERA_DISTANCE : float = 1
@export var CAMERA_MOVE_LERP : float = .15

var input_dir : Vector2
var direction : Vector3

func enter():
	print("Entered Hover state.")
	WING_STATES.change_state("WingsFlapping")
	
	CAMERA_MOVEMENT.move_cam(CAMERA_DISTANCE, CAMERA_POSITION, CAMERA_MOVE_LERP)
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func physics_update(delta: float):
	# change to idle state when on ground
	if player_controller.is_on_floor():
		state_machine.change_state("IdleState")
	
	# Get the input direction and handle the movement/deceleration.
	input_dir = Input.get_vector("left", "right", "forward", "backward")
	var input_vert = Input.get_axis("break", "jump")
	direction = (camera_pivot_y.transform.basis * Vector3(input_dir.x, input_vert, input_dir.y)).normalized()
		
	handle_velocity(delta)
	
	
func update(_delta: float):
	# detecting double tap to enable flight state
	fly_timer -= _delta
	
	if Input.is_action_just_pressed("jump"):
		if fly_timer > 0:
			player_controller.velocity = CAMERA_MOVEMENT.get_camera_forward().normalized() * FLIGHT_TRANSITION_VELOCITY
			state_machine.change_state("FlyState")
			return
		
		fly_timer = TIME_FOR_DOUBLE_TAP_FLY
		
	CAMERA_MOVEMENT.look_towards_y(input_dir.x, CAMERA_FOLLOW_STRENGTH * _delta * player_controller.velocity.normalized().length(), 0.0)

	
func handle_velocity(delta):	
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * HOVER_SPEED, delta * HOVER_INERTIA)
	player_controller.velocity.y = lerp(player_controller.velocity.y, direction.y * HOVER_SPEED, delta * HOVER_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * HOVER_SPEED, delta * HOVER_INERTIA)
	
	player_controller.move_and_slide()
	
	var look_direction_flat = CAMERA_MOVEMENT.get_camera_forward()
	look_direction_flat.y = 0
	
	extension_functions.handle_model_transform(look_direction_flat)
	
