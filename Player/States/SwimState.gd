extends State

class_name SwimState


@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../CameraControl/CameraPivotY"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

@export var WING_STATES : WingStateMachine
@export var UP_FLOAT_STRENGTH : float = 10
@export var MAX_VELOCITY : float = 8
@export var SWIM_SPEED : float = 4
@export var SWIM_INERTIA : float = 10
@export var CAMERA_MOVEMENT : CameraMovement
@export var CAMERA_FOLLOW_STRENGTH = .05

var direction
var flight_timer

func enter():
	WING_STATES.change_state("wingsidle")

func update(delta: float):
	if Input.is_action_pressed("jump"):
		state_machine.change_state("HoverState")
		return
	
	if player_controller.velocity.length() > MAX_VELOCITY:
		player_controller.velocity = player_controller.velocity.normalized() * MAX_VELOCITY
	
	# Add the gravity.
	player_controller.velocity.y += UP_FLOAT_STRENGTH * delta
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (camera_pivot_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	handle_velocity(delta)
	
	CAMERA_MOVEMENT.look_towards_y(input_dir.x, CAMERA_FOLLOW_STRENGTH * delta * player_controller.velocity.normalized().length(), 0.0)
	
	
func handle_velocity(delta):	
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * SWIM_SPEED, delta * SWIM_INERTIA)
	player_controller.velocity.y = lerp(player_controller.velocity.y, direction.y * SWIM_SPEED, delta * SWIM_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * SWIM_SPEED, delta * SWIM_INERTIA)
	
	player_controller.move_and_slide()
	
	var look_at_flat = player_controller.velocity
	look_at_flat.y = 0
	extension_functions.handle_model_transform(look_at_flat, Vector3.UP, .05)	
