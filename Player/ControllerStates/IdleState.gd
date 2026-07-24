extends State

class_name IdleState


@onready var pivot: Node3D = $"../../CameraPivot"
@onready var player_controller: CharacterBody3D = $"../.."
@onready var walk_state: WalkState = $"../WalkState"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

var direction


func enter():
	print("Entering Idle state")
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func physics_update(delta):	
	# Switch to fall state if player controller is not on ground.
	if !player_controller.is_on_floor():
		state_machine.change_state("fallstate")
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (player_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction.length() > 0.0:
		state_machine.change_state("walkstate")
		
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
	
	handle_velocity(delta)
	
func handle_velocity(delta):	
	player_controller.velocity.x = lerp(player_controller.velocity.x, 0.0, delta * walk_state.GROUND_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, 0.0, delta * walk_state.GROUND_INERTIA)
	
	player_controller.move_and_slide()
	
	extension_functions.handle_model_transform(direction)
