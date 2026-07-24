extends State

class_name IdleState


@onready var pivot: Node3D = $"../../CameraPivot"
@onready var player_controller: CharacterBody3D = $"../.."
@onready var walk_state: WalkState = $"../WalkState"


func enter():
	print("Entering Idle state")
	
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func physics_update(_delta):
	walk_state.handle_velocity(_delta)
	
	# Switch to fall state if player controller is not on ground.
	if !player_controller.is_on_floor():
		state_machine.change_state("fallstate")
	
func handle_input(_event):
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction.length() > 0.0:
		state_machine.change_state("walkstate")
		
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
