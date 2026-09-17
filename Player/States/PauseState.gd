extends State

class_name PauseState


@export var MAIN_CAMERA : Camera3D
@export var CAM_LERP_UP : float = .1
@export var CAM_LERP_DOWN : float = .2
@export var CAM_HEIGHT : float = 15

@onready var extension_functions: PlayerExtensionFunctions = $"../.."

var start_pos : Transform3D
var target_pos : Vector3
var look_pos : Vector3
var cam_spring : SpringArm3D

func _ready() -> void:
	MenuManager.has_paused.connect(enter_pause_state)
	MenuManager.has_unpaused.connect(exit_pause_state)

func enter_pause_state():
	state_machine.change_state(name)

func exit_pause_state():
	state_machine.change_state(state_machine.previous_state.name)
	
func enter():
	start_pos = MAIN_CAMERA.transform
	cam_spring = MAIN_CAMERA.get_parent()
	MAIN_CAMERA.reparent(self)
	
	target_pos = MAIN_CAMERA.global_position + Vector3.UP * CAM_HEIGHT
	look_pos = MAIN_CAMERA.global_position + Vector3.UP * 999.9 + -MAIN_CAMERA.global_basis.z * .1

	cam_transition_up()
	
func exit():
	MAIN_CAMERA.reparent(cam_spring)
	MAIN_CAMERA.transform = start_pos
	#cam_transition_down()

func cam_transition_up():
	if MAIN_CAMERA.get_parent() == cam_spring:
		return
	
	MAIN_CAMERA.global_position = lerp(MAIN_CAMERA.global_position, target_pos, CAM_LERP_UP)
	
	var start_rot = MAIN_CAMERA.rotation
	MAIN_CAMERA.global_transform = MAIN_CAMERA.global_transform.looking_at(look_pos)
	var end_rot = MAIN_CAMERA.rotation
	MAIN_CAMERA.rotation = start_rot
	
	MAIN_CAMERA.rotation.y = lerp_angle(MAIN_CAMERA.rotation.y, end_rot.y, CAM_LERP_UP)
	MAIN_CAMERA.rotation.x = lerp_angle(MAIN_CAMERA.rotation.x, end_rot.x, CAM_LERP_UP)
	
	if MAIN_CAMERA.global_position.distance_to(target_pos) > .1:
		await get_tree().process_frame
		cam_transition_up()
	
func cam_transition_down():
	MAIN_CAMERA.transform = lerp(MAIN_CAMERA.transform, start_pos, CAM_LERP_DOWN)
	
	if MAIN_CAMERA.position.distance_to(start_pos.origin) < .1:
		return
		
	await get_tree().process_frame
	cam_transition_down()
