extends Placeable

class_name BranchInteractable


@export var RANDOM_BRANCH_ROTATION_RANGE = 45.0
@export_range(0, 1) var CHANCE_TO_SPLIT = .4


func grow_branch_random(chance = .5):
	if randf() > chance:
		return
	
	var scene = PackedScene.new()
	scene.pack(self)
	
	var new_branch : BranchInteractable = scene.instantiate()
	var branch_pivot : Marker3D = new_branch.get_child(2)
	get_parent().add_child(new_branch)
	
	branch_pivot.global_transform = $EndPivot.global_transform
	branch_pivot.rotate_x(randf_range(deg_to_rad(-RANDOM_BRANCH_ROTATION_RANGE), deg_to_rad(RANDOM_BRANCH_ROTATION_RANGE)))
	branch_pivot.rotate_y(randf_range(deg_to_rad(-RANDOM_BRANCH_ROTATION_RANGE), deg_to_rad(RANDOM_BRANCH_ROTATION_RANGE)))
	
	new_branch.global_position = branch_pivot.global_position + branch_pivot.global_basis.x * branch_pivot.gizmo_extents
	new_branch.global_rotation = branch_pivot.global_rotation
	
	new_branch.grow_branch_random(chance)
	
	forward_connections.append(new_branch)
	new_branch.backwards_connections.append(self)
	
	if randf() < CHANCE_TO_SPLIT:
		grow_branch_random(chance)
