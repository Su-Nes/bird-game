extends State

class_name FlyState


@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../CameraPivotY"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"
@onready var extension_functions: PlayerExtensionFunctions = $"../.."

@export var WING_STATES : WingStateMachine

@export_category("Velocity calculation")
@export var ANGLE_ACCELERATION_CURVE: Curve
@export var ANGLE_ACCELERATION_STRENGTH: float = -9.81
@export var AUTO_ANGLE_MULT : float = 50
@export var THRUST_CURVE : Curve
@export var THRUST_STRENGTH : float = 5
@export var THRUST_STRENGTH_PASSIVE : float = 1
@export var DRAG_CURVE : Curve
@export var DRAG_STRENGTH : float = -.4
@export var BREAK_CURVE : Curve
@export var BREAK_STRENGTH : float = 200
@export var MINUMUM_VELOCITY : float = .2
@export var CRASH_VELOCITY : float = 10
@export var CRASH_SPEED_MOD : float = .5

@export_category("Controls")
@export var PITCH_ROT_SPEED : float = 1.5
@export var YAW_ROT_SPEED : float = 1.25
@export var ROLL_ROT_SPEED : float = 5
@export var BREAK_TURN_MODIFIER : float = 2.5

@export_category("Stamina")
@export var STATS_CONTROLLER : StatsController
@export var CONSTANT_FLAP_COST : float = 12
@export var TIME_FOR_FLAP : float = .1
@export var FLAP_COST : float = 15

@export_category("Clamps")
@export var PITCH_ROT_LIMIT : float = 80.0
@export var PITCH_ROLL_COMPENSATION : float = .5
@export var ROLL_ROT_LIMIT : float = 60.0

@export_category("Camera")
@export var CAMERA_MOVEMENT : CameraRotation
@export var CAMERA_FOLLOW_STRENGTH = .5
@export var CAMERA_RESET_TIME: float = .5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var flap_timer : float
var forward_v : float
var angle_of_attack : float
var rotation_mod : float

func enter():
	print("Entered Fly state.")
	WING_STATES.change_state("wingsGliding")
	CAMERA_MOVEMENT.disable_look_timer = 999
	
	forward_v = player_controller.velocity.length()
	rotation_mod = 1

func update(delta: float):
	# Return to idle state on ground
	if player_controller.is_on_floor():
		state_machine.change_state("idleState")

	# Thrust
	if Input.is_action_pressed("jump"):
		flap_timer += delta
		handle_constant_flap(delta)
	
	if Input.is_action_just_released("jump"):
		if flap_timer < TIME_FOR_FLAP:
			handle_flap()
			flap_timer = 0
			return
			
		flap_timer = 0
		state_machine.ANIMATOR.play("Glide", .5)
		
	# Breaking
	if Input.is_action_pressed("break") and WING_STATES.ANIMATOR.current_animation.get_basename() != "Flap":
		state_machine.ANIMATOR.play("Break")
		
		forward_v -= BREAK_CURVE.sample(player_controller.velocity.length()) * BREAK_STRENGTH * delta
		rotation_mod = BREAK_TURN_MODIFIER
		
	if Input.is_action_just_released("break") and WING_STATES.ANIMATOR.current_animation.get_basename() == "Break":
		WING_STATES.change_state("WingsGliding")
		rotation_mod = 1
	
	# Get angle of attack (mesh rotation)
	angle_of_attack = extension_functions.MESH.rotation.x
	
	# DIRECTIONAL CONTROLS
	# Clamp pitch rotation
	var pitch_input = Input.get_axis("forward", "backward")
	if extension_functions.MESH.rotation.x >= deg_to_rad(PITCH_ROT_LIMIT): # limit pitch up 
		pitch_input = clamp(pitch_input, -1, 0)
	
	if extension_functions.MESH.rotation.x <= -deg_to_rad(PITCH_ROT_LIMIT): # limit pitch down
		pitch_input = clamp(pitch_input, 0, 1)
		
	# Auto pitch when low velocity
	if player_controller.velocity.length() <= 4:
		pitch_input = clamp(pitch_input, -1, 0)
		
		pitch_input -= AUTO_ANGLE_MULT * delta #TO-DO: make this smoother

		if Input.is_action_pressed("break"):
			state_machine.change_state("HoverState")
		
	# Clamp roll input (oooo you could smoothly clamp these with some more math)
	var roll_input = Input.get_axis("right", "left")
	if extension_functions.MESH.rotation.z >= deg_to_rad(ROLL_ROT_LIMIT):
		roll_input = clamp(roll_input, -1, 0)
		
	if extension_functions.MESH.rotation.z <= -deg_to_rad(ROLL_ROT_LIMIT):
		roll_input = clamp(roll_input, 0, 1)
		
	# Rotate pitch
	var flat_pitch_vector = extension_functions.MESH.global_basis.x
	flat_pitch_vector.y = 0
	player_controller.velocity = player_controller.velocity.rotated(extension_functions.MESH.global_basis.x, pitch_input * PITCH_ROT_SPEED * rotation_mod * delta)

	# Rotate yaw
	player_controller.velocity = player_controller.velocity.rotated(Vector3.UP, Input.get_axis("right", "left") * YAW_ROT_SPEED * rotation_mod * delta)
		# Compensate for roll rotation
	player_controller.velocity = player_controller.velocity.rotated(extension_functions.MESH.global_basis.x, PITCH_ROLL_COMPENSATION * abs(Input.get_axis("right", "left")) * delta)

	# Roll
	player_controller.velocity = player_controller.velocity.rotated(extension_functions.MESH.global_basis.z, roll_input * ROLL_ROT_SPEED * delta)
	extension_functions.MESH.global_rotate(extension_functions.MESH.global_basis.z, roll_input * ROLL_ROT_SPEED * delta)	
	
	#TO_DO rotate camera with roll movevent
	#CAMERA_MOVEMENT.roll(Input.get_axis("right", "left") * ROLL_ROT_SPEED * delta)
		
	extension_functions.handle_model_transform(player_controller.velocity)
	
	CAMERA_MOVEMENT.look_towards_vector(player_controller.velocity, CAMERA_FOLLOW_STRENGTH * delta, CAMERA_RESET_TIME, extension_functions.MESH.global_basis.y)	
	
	
func physics_update(_delta: float):
	handle_flight_velocity(_delta)
	
	
func handle_constant_flap(delta: float):
	if WING_STATES.ANIMATOR.current_animation.get_basename() == "Flap":
		return
		
	if STATS_CONTROLLER.spend_stamina(CONSTANT_FLAP_COST * delta, .1):
		forward_v += THRUST_CURVE.sample(player_controller.velocity.length()) * THRUST_STRENGTH_PASSIVE * delta
		state_machine.ANIMATOR.play("Flapping", .2)
		
func handle_flap():
	if WING_STATES.ANIMATOR.current_animation.get_basename() == "Flap":
		return
		
	if STATS_CONTROLLER.spend_stamina(FLAP_COST):
		forward_v += THRUST_CURVE.sample(player_controller.velocity.length()) * THRUST_STRENGTH
		state_machine.ANIMATOR.play("Flap", .5)
	else:
		Input.action_release("jump")
	
func handle_flight_velocity(_delta: float):
	#TO-DO (optional): Change all the curves to mathematical algorhythms
	#print(player_controller.velocity.length())
	# Add acceleration due to grav
	forward_v += ANGLE_ACCELERATION_CURVE.sample(angle_of_attack) * ANGLE_ACCELERATION_STRENGTH
	
	# Add forward velocity
	player_controller.velocity = player_controller.velocity.normalized() * forward_v

	# Add drag
	forward_v += DRAG_CURVE.sample(player_controller.velocity.length()) * DRAG_STRENGTH
	
	# Force minumum velocity
	if player_controller.velocity.length() < MINUMUM_VELOCITY:
		forward_v += 1

	# Handle collisions
	var collision_info = player_controller.move_and_collide(player_controller.velocity * _delta)
	if collision_info:
		if player_controller.velocity.length() > CRASH_VELOCITY:
			state_machine.stored_vector = player_controller.velocity.bounce(collision_info.get_normal()) * CRASH_SPEED_MOD
			state_machine.change_state("CrashState")
		else:
			state_machine.change_state("IdleState")
