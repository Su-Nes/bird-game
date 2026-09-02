extends Node3D

class_name PlayerExtensionFunctions

@export var MESH_OFFSET : Vector3
@export var LOOK_AT_LERP : float
@export var MESH: Node3D

@onready var player_controller: CharacterBody3D = $"."

func handle_model_transform(direction: Vector3):
	# set model position
	var target_pos = player_controller.global_transform.origin + MESH_OFFSET
	MESH.global_transform.origin = target_pos
		
	# set model rotation to look in the direction of passed variable
	var look_pos = target_pos + direction
	look_pos.y = MESH.global_transform.origin.y
	var start_rot = MESH.global_rotation
	
	if MESH.global_transform.origin.is_equal_approx(look_pos):
		return
	
	MESH.global_transform = MESH.global_transform.looking_at(look_pos)
	var end_rot = MESH.global_rotation

	MESH.global_rotation.x = lerp_angle(start_rot.x, end_rot.x, LOOK_AT_LERP)
	MESH.global_rotation.y = lerp_angle(start_rot.y, end_rot.y, LOOK_AT_LERP)
	MESH.global_rotation.z = lerp_angle(start_rot.z, end_rot.z, LOOK_AT_LERP)
