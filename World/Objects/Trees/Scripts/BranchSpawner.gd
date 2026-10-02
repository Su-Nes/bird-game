extends Node3D

class_name BranchSpawner


@export var SPAWN_DISTANCE : float = 100
@export var BRANCHES : Array[PackedScene]
@export var SPAWN_MARKER_PARENT : Node
@export var SPAWN_OFFSET : float = 0
@export var RAND_BRANCHES_PER_METER : Vector2
@export var RAND_ROTATION_TOWARD_BRANCH_DIRECTION : Vector2 = Vector2(45, 90)
@export_range(0, 1) var CHANCE_FOR_BRANCH_GROWTH : float = .5

var player : Node3D

func _ready() -> void:
	player = get_tree().get_nodes_in_group("Player")[0]
	
func _physics_process(_delta: float) -> void:
	if !player:
		return
		
	if player.global_position.distance_to(global_position) < SPAWN_DISTANCE:
		spawn_branches()
		player = null

func spawn_branches() -> void:
	for marker in SPAWN_MARKER_PARENT.get_children(): # Don't spawn if tree has branches from a save file 
		if marker.get_child_count() > 0:
			return
	
	for spawn_marker : Marker3D in SPAWN_MARKER_PARENT.get_children():
		var branch_count := randf_range(RAND_BRANCHES_PER_METER.x, RAND_BRANCHES_PER_METER.y)
		var branches_per_meter = roundi(spawn_marker.gizmo_extents * scale.x * branch_count)

		for n in branches_per_meter:
			var branch_scene = BRANCHES[randi_range(0, BRANCHES.size() - 1)]
			var new_branch : Node3D = branch_scene.instantiate()
			var branch_pivot : Marker3D = new_branch.get_child(2)
			spawn_marker.add_child(new_branch)
			
			new_branch.scale /= scale
			
			branch_pivot.global_position = spawn_marker.global_position - spawn_marker.global_basis.z * spawn_marker.gizmo_extents * randf() - spawn_marker.global_basis.z * SPAWN_OFFSET

			branch_pivot.rotate_y(randf_range(deg_to_rad(RAND_ROTATION_TOWARD_BRANCH_DIRECTION.x), deg_to_rad(RAND_ROTATION_TOWARD_BRANCH_DIRECTION.x)))
			branch_pivot.rotate_z(deg_to_rad(360) * randf())
			
			new_branch.global_position = branch_pivot.global_position + branch_pivot.global_basis.x * branch_pivot.gizmo_extents
			new_branch.global_rotation = branch_pivot.global_rotation
			
			if !new_branch is BranchInteractable:
				return
			elif new_branch is BranchInteractable: # Type-ing
				new_branch.has_physics(true, false)
				new_branch.grow_branch_random(CHANCE_FOR_BRANCH_GROWTH)
