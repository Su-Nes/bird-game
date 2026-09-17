extends State

class_name FaintState


@export var CAMERA_MOVEMENT : CameraMovement

@onready var player_controller : CharacterBody3D = $"../.."
@onready var extension_functions : PlayerExtensionFunctions = $"../.."

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	StatController.has_fainted.connect(enter_faint_state)
	
func enter_faint_state():
	state_machine.change_state(name)

func enter():	
	CAMERA_MOVEMENT.enabled = false
	
	state_machine.ANIMATOR.play("Crash")
	MenuManager.on_faint()

func update(delta: float):
	player_controller.velocity += Vector3.DOWN * gravity * delta

	handle_velocity(delta)
	
func handle_velocity(delta):	
	player_controller.velocity.x = lerp(player_controller.velocity.x, 0.0, delta * 5)
	player_controller.velocity.z = lerp(player_controller.velocity.z, 0.0, delta * 5)
	
	player_controller.move_and_slide()
	
	extension_functions.handle_model_transform(-extension_functions.MESH.global_basis.z)
