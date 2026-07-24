extends Node3D

class_name PlayerExtensionFunctions

@export var MESH_OFFSET : Vector3
@export var LOOK_AT_LERP : float

@onready var player_controller: CharacterBody3D = $"."
@onready var mesh: Node3D = $Mesh

func handle_model_transform(direction: Vector3):
	var target_pos = player_controller.global_transform.origin + MESH_OFFSET
	mesh.global_transform.origin = target_pos
	
	if mesh.global_transform.origin.distance_to(target_pos + direction) < 0.01:
		return
		
	var look_pos = target_pos + direction
	look_pos.y = mesh.global_transform.origin.y
	var start_rot = mesh.global_rotation
	mesh.global_transform = mesh.global_transform.looking_at(look_pos)
	var end_rot = mesh.global_rotation

	mesh.global_rotation.x = lerp_angle(start_rot.x, end_rot.x, LOOK_AT_LERP)
	mesh.global_rotation.y = lerp_angle(start_rot.y, end_rot.y, LOOK_AT_LERP)
	mesh.global_rotation.z = lerp_angle(start_rot.z, end_rot.z, LOOK_AT_LERP)
