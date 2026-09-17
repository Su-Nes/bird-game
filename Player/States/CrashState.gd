extends State

class_name CrashState

@export var ANIMATOR : AnimationPlayer
@export var CRASH_DAMAGE_MULT : float = 2
@export var CRASH_DURATION : float = 2
@export var CRASH_VELOCITY : float = 10
@export var CRASH_SPEED_MOD : float = .5

@onready var player_controller: CharacterBody3D = $"../.."
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func enter():
	ANIMATOR.play("Crash")
	
	if !StatController.spend_max_stamina(player_controller.velocity.length() * CRASH_DAMAGE_MULT):
		HitStopManager.hit_stop_short()

	player_controller.velocity = state_machine.stored_vector
	
	await get_tree().create_timer(CRASH_DURATION).timeout
	if StatController.fainted:
		return
	
	state_machine.change_state("IdleState")

func physics_update(_delta: float):
	player_controller.velocity += Vector3.DOWN * gravity * _delta
	
	extension_functions.handle_model_position(player_controller.position)
	
	# Handle collisions
	var collision_info = player_controller.move_and_collide(player_controller.velocity * _delta)
	if collision_info:
		if player_controller.velocity.length() > CRASH_VELOCITY:
			state_machine.stored_vector = player_controller.velocity.bounce(collision_info.get_normal()) * CRASH_SPEED_MOD
			state_machine.change_state("CrashState")
		else:
			state_machine.change_state("IdleState")
