extends Node

class_name BuildController


@export var SHAPE_RAY : ShapeCast3D
@export var GRAB_SCRIPT : GrabScript
@export var ROTATION_SPEED : float = 10
@export var GHOST_MATERIAL : StandardMaterial3D
@export var ERROR_MATERIAL : StandardMaterial3D

@onready var camera_3d: Camera3D = $"../CameraControl/CameraPivotY/CameraPivotX/CameraSpring/Camera3D"

var current_buildable : Placeable
var ghost : Node3D
var ghost_material : MeshInstance3D
var rotation : Vector3
var can_place = false

func _ready() -> void:
	Signals.build_controller = self

func initiate_building(block: Placeable): ## Block must have CollisionShape3D as child 0 and MeshInstance3D as child 1
	if current_buildable:
		stop_building()
	
	if ghost:
		ghost.queue_free()
	print("%s is fuckin building" % [block.name])
	# Create ghost mesh
	current_buildable = block
	var ghost_scene = PackedScene.new()
	ghost_scene.pack(block)

	ghost = ghost_scene.instantiate()
	ghost.get_child(0).queue_free() # Get rid of collider on the placeable block
	
	SHAPE_RAY.add_child(ghost)
	var ray_box : BoxShape3D = SHAPE_RAY.shape
	var block_collider : CollisionShape3D = block.get_child(0)
	var collider_shape : BoxShape3D = block_collider.shape
	ray_box.size.x = collider_shape.size.x
	
	ghost_material = ghost.get_child(1) # Get mesh
	ghost_material.material_override = GHOST_MATERIAL


func _process(_delta: float) -> void:
	if !current_buildable:
		return
		
	ghost.global_rotation = SHAPE_RAY.global_rotation
	SHAPE_RAY.rotate_z(Input.get_axis("rotate_R", "rotate_L") * ROTATION_SPEED * _delta)
		
	can_place = SHAPE_RAY.is_colliding()
	
	if !can_place:
		ghost_material.material_override = ERROR_MATERIAL
		ghost.position = SHAPE_RAY.target_position
		return

	var collision_distance = SHAPE_RAY.get_collision_point(0).distance_to(camera_3d.global_position)
	var ghost_position = camera_3d.global_position - camera_3d.global_basis.z * collision_distance

	# Move ghost to ray intersect position
	if can_place:
		ghost_material.material_override = GHOST_MATERIAL
		ghost.global_position = ghost_position
		
		
func place() -> bool:
	if !current_buildable or !can_place:
		return false
	
	current_buildable.on_placed()
	current_buildable.reparent(SHAPE_RAY)
	
	var collision_distance = SHAPE_RAY.get_collision_point(0).distance_to(camera_3d.global_position)
	var placement_position = camera_3d.global_position - camera_3d.global_basis.z * collision_distance
	
	current_buildable.global_position = placement_position

	current_buildable.rotation = ghost.rotation
	current_buildable.reparent(get_tree().root)
	current_buildable.is_grabbed = false
	current_buildable.has_physics(true, false)
	
	stop_building()
	
	return true
	
func stop_building():
	if ghost:
		ghost.queue_free()

	if current_buildable:
		current_buildable = null
