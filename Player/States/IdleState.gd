extends State

class_name IdleState

@export var PLAYER_CONTROLLER: CharacterBody3D

@onready var pivot: Node3D = $"../../CameraPivot"
@onready var walk_state: WalkState = $"../WalkState"


func enter():
	print("Entering Idle state")
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func physics_update(_delta):
	walk_state.handle_velocity(_delta)
	
	# Add the gravity.
	if not PLAYER_CONTROLLER.is_on_floor():
		PLAYER_CONTROLLER.velocity.y -= gravity * _delta
		
	PLAYER_CONTROLLER.move_and_slide()
	
func handle_input(_event):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction.length() > 0.0:
		state_machine.change_state("walkstate")
		
func handle_velocity(delta):
	print(PLAYER_CONTROLLER.velocity.length())
	if PLAYER_CONTROLLER.velocity.length() <= 0:
		return
	
	if PLAYER_CONTROLLER.is_on_floor():
		PLAYER_CONTROLLER.velocity.x = lerp(PLAYER_CONTROLLER.velocity.x, walk_state.direction.x * walk_state.speed, delta * walk_state.GROUND_INERTIA)
		PLAYER_CONTROLLER.velocity.z = lerp(PLAYER_CONTROLLER.velocity.z, walk_state.direction.z * walk_state.speed, delta * walk_state.GROUND_INERTIA)
	else:
		PLAYER_CONTROLLER.velocity.x = lerp(PLAYER_CONTROLLER.velocity.x, walk_state.direction.x * walk_state.speed, delta * walk_state.AIR_INERTIA)
		PLAYER_CONTROLLER.velocity.z = lerp(PLAYER_CONTROLLER.velocity.z, walk_state.direction.z * walk_state.speed, delta * walk_state.IR_INERTIA)

	PLAYER_CONTROLLER.move_and_slide()
