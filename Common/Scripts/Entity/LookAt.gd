extends Node3D

class_name LookAt


@export_category("Targeting")
@export var TARGET : Node3D
@export var TARGET_GROUP : String

@export_category("Settings")
@export var FOLLOW_Y_POS = true

func _process(_delta: float) -> void:
	if !TARGET:
		if get_tree().get_node_count_in_group(TARGET_GROUP) > 0:
			TARGET = get_tree().get_nodes_in_group(TARGET_GROUP)[0]
		return
		
	if !TARGET.is_inside_tree():
		return
	
	var target_pos : Transform3D = TARGET.global_transform
	target_pos.origin.y = global_position.y
		
	global_transform = global_transform.looking_at(target_pos.origin)
	
	if FOLLOW_Y_POS:
		global_position.y = TARGET.global_position.y
	
	#TO-DO: Make this lerp and shit
