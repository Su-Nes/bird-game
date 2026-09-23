extends State

class_name PauseState


@export var CAMERA_MOVEMENT : CameraMovement
@export var CAM_LERP_UP : float = .1
@export var CAM_LERP_DOWN : float = .2
@export var CAM_HEIGHT : float = 15

@onready var extension_functions: PlayerExtensionFunctions = $"../.."

var going_up : bool
var look_pos : Vector3

func _ready() -> void:
	MenuManager.has_paused.connect(enter_pause_state)
	MenuManager.has_unpaused.connect(exit_pause_state)

func enter_pause_state():
	state_machine.change_state(name)

func exit_pause_state():
	state_machine.change_state(state_machine.previous_state.name)
	
func enter():
	CAMERA_MOVEMENT.rot_clamped = false
	look_pos = CAMERA_MOVEMENT.global_position + Vector3.UP * 999.9 + CAMERA_MOVEMENT.get_camera_forward() * .1

	going_up = true
	cam_transition_up()
	
func exit():
	going_up = false
	cam_transition_down()

func cam_transition_up():
	if !going_up:
		return
	
	CAMERA_MOVEMENT.pivot.position.y = lerp(CAMERA_MOVEMENT.pivot.position.y, CAM_HEIGHT, CAM_LERP_UP)
	
	CAMERA_MOVEMENT.rotation.x = lerp(CAMERA_MOVEMENT.rotation.x, deg_to_rad(90), CAM_LERP_UP)
	
	if CAMERA_MOVEMENT.pivot.position.y < CAM_HEIGHT - .1:
		await get_tree().process_frame
		cam_transition_up()
	
func cam_transition_down():
	if going_up:
		return
	
	CAMERA_MOVEMENT.pivot.position.y = lerp(CAMERA_MOVEMENT.pivot.position.y, 0.0, CAM_LERP_DOWN)
	
	CAMERA_MOVEMENT.rotation.x = lerp_angle(CAMERA_MOVEMENT.rotation.x, 0, CAM_LERP_UP)
	
	if CAMERA_MOVEMENT.pivot.position.y < .1:
		CAMERA_MOVEMENT.rot_clamped = false

		CAMERA_MOVEMENT.pivot.position.y = 0
		return
		
	if !get_tree():
		return
	await get_tree().process_frame # idk why this gave an error sometimes
	cam_transition_down()
