extends Node3D

class_name PlayerExtensionFunctions

@export var MESH_OFFSET : Vector3
@export var LOOK_AT_LERP_Z : float
@export var MESH: Node3D

@onready var player_controller: CharacterBody3D = $"."

func handle_model_position(pos: Vector3):
	# set model position
	var target_pos = pos + MESH_OFFSET
	MESH.global_transform.origin = target_pos

func handle_model_transform(direction: Vector3, up = Vector3.UP, lerp_strength = .2):
	# set model position
	var target_pos = player_controller.global_transform.origin + MESH_OFFSET
	MESH.global_transform.origin = target_pos
		
	# set model rotation to look in the direction of passed variable
	var look_pos = target_pos + direction
	var start_rot = MESH.global_rotation
	
	if MESH.global_transform.origin.is_equal_approx(look_pos):
		return

	look_pos -= MESH.global_basis.z * .1 # To avoid colinear vectors in the upcoming line
		
	MESH.global_transform = MESH.global_transform.looking_at(look_pos, up)
	var end_rot = MESH.global_rotation

	MESH.global_rotation.x = lerp_angle(start_rot.x, end_rot.x, lerp_strength)
	MESH.global_rotation.y = lerp_angle(start_rot.y, end_rot.y, lerp_strength)
	MESH.global_rotation.z = lerp_angle(start_rot.z, end_rot.z, LOOK_AT_LERP_Z)
	
func rotate_mesh_forward_axis(angle: float) -> Vector3:
	MESH.rotate_z(angle)
	return MESH.basis.z
	
func rotate_to_floor_normal(lerp_strength = .2):
	# set model position
	var target_pos = player_controller.global_transform.origin + MESH_OFFSET
		
	# set model rotation to look in the direction of passed variable
	var look_pos = target_pos + player_controller.get_floor_normal().cross(MESH.global_basis.x)
	var start_rot = MESH.global_rotation
	
	if MESH.global_transform.origin.is_equal_approx(look_pos):
		return
	
	MESH.global_transform = MESH.global_transform.looking_at(look_pos)
	var end_rot = MESH.global_rotation

	MESH.global_rotation.x = lerp_angle(start_rot.x, end_rot.x, lerp_strength)
	MESH.global_rotation.y = lerp_angle(start_rot.y, end_rot.y, lerp_strength)
	MESH.global_rotation.z = lerp_angle(start_rot.z, end_rot.z, LOOK_AT_LERP_Z)
