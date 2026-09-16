extends StaticBody3D

class_name BranchSpawner


@export var BRANCHES : Array[PackedScene]
@export var SPAWN_MARKER_PARENT : Node
@export var SPAWN_GROUP_PER_BRANCH : Vector2
@export var RAND_ROTATION_TOWARD_BRANCH_DIRECTION : Vector2
@export_range(0, 1) var CHANCE_FOR_BRANCH_GROWTH : float


func _ready() -> void:
	for spawn_marker : Marker3D in SPAWN_MARKER_PARENT.get_children():
		for n in randi_range(roundi(SPAWN_GROUP_PER_BRANCH.x), roundi(SPAWN_GROUP_PER_BRANCH.y)):
			var branch_scene = BRANCHES[randi_range(0, BRANCHES.size() - 1)]
			var new_branch : BranchInteractable = branch_scene.instantiate()
			var branch_pivot : Marker3D = new_branch.get_child(2)
			spawn_marker.add_child(new_branch)
			
			new_branch.scale /= scale
			
			branch_pivot.global_position = spawn_marker.global_position - spawn_marker.global_basis.z * spawn_marker.gizmo_extents * randf()

			branch_pivot.rotate_y(randf_range(deg_to_rad(RAND_ROTATION_TOWARD_BRANCH_DIRECTION.x), deg_to_rad(RAND_ROTATION_TOWARD_BRANCH_DIRECTION.x)))
			branch_pivot.rotate_z(deg_to_rad(360) * randf())
			
			
			new_branch.global_position = branch_pivot.global_position + branch_pivot.global_basis.x * branch_pivot.gizmo_extents
			new_branch.global_rotation = branch_pivot.global_rotation
			
			new_branch.has_physics(true, false)
			
			new_branch.grow_branch_random(CHANCE_FOR_BRANCH_GROWTH)
