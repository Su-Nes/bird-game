extends State

class_name FlyState


@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../CameraPivotY"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

@export var WING_STATES : WingStateMachine
@export_category("Parameters")
@export var START_SPEED = 15.0
@export var GRAVITY_MOD : float
@export var PITCH_ROT_SPEED = 1.0
@export var YAW_ROT_SPEED = 1.0
@export_category("Camera")
@export var CAMERA_MOVEMENT : CameraRotation
@export var CAMERA_FOLLOW_STRENGTH = .5
@export var CAMERA_RESET_TIME: float = .5

var flight_direction : Vector3
var input_direction : Vector3
var speed : float
var acceleration : float
var gravity_accel : float

func enter():
	print("Entered Fly state.")
	WING_STATES.change_state("wingsFlapping")
	CAMERA_MOVEMENT.disable_look_timer = 999
	
	flight_direction = player_controller.velocity.normalized()
	speed = START_SPEED

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func physics_update(delta: float):
	# Add the gravity.
	#if !player_controller.is_on_floor():
		#player_controller.velocity.y -= gravity * delta * GRAVITY_MOD
	#else:
		#state_machine.change_state("idlestate")
		
	# TO_DO code something when you crash into a wall
	#if player_controller.is_on_wall() && player_controller.velocity
		
		
	# Rotate pitch
	var pitch_vector = player_controller.velocity
	pitch_vector.y = 0
	pitch_vector = pitch_vector.cross(pitch_vector.rotated(Vector3.UP, deg_to_rad(90))).normalized()
	flight_direction = flight_direction.rotated(extension_functions.MESH.global_basis.x, Input.get_axis("forward", "backward") * PITCH_ROT_SPEED * delta)
			
	# Rotate yaw
	flight_direction = flight_direction.rotated(Vector3.UP, Input.get_axis("right", "left") * YAW_ROT_SPEED * delta)
	
	flight_direction = flight_direction.normalized()
	
	speed += acceleration + gravity_accel
	player_controller.velocity = flight_direction * speed
	
		
	extension_functions.handle_model_transform(flight_direction)
	
	CAMERA_MOVEMENT.look_towards_vector(flight_direction, CAMERA_FOLLOW_STRENGTH * delta * player_controller.velocity.normalized().length(), CAMERA_RESET_TIME)	
	
	player_controller.move_and_slide()
	
	
func exit():
	#CAMERA_MOVEMENT.reset_rotation = 
	pass
