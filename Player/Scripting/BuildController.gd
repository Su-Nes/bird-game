extends Node

class_name BuildController


@export var SHAPE_RAY : ShapeCast3D
@export var GRAB_SCRIPT : GrabScript
@export var STATE_MACHINE : StateMachine
@export var INACTIVE_STATES : Array[String]
@export var SNAP_ROTATION : float = 5
@export var ROTATION_INTERVAL : float = .1
@export var GHOST_MATERIAL : StandardMaterial3D
@export var ERROR_MATERIAL : StandardMaterial3D

@onready var camera_3d: Camera3D = $"../CameraControl/CameraPivotY/CameraPivotX/CameraSpring/Camera3D"

var current_buildable : Placeable
var ghost : Placeable
var ghost_material : MeshInstance3D
var z_rotation : float
var can_place = false

func _ready() -> void:
	Signals.build_controller = self
	STATE_MACHINE.state_changed.connect(check_state)
	
func check_state(state: String):
	if INACTIVE_STATES.has(state.to_lower()):
		hide_ghost()
	else:
		show_ghost()

func initiate_building(block: Placeable):
	if current_buildable:
		stop_building()
	
	if ghost:
		ghost.queue_free()

	# Create ghost mesh
	current_buildable = block
	var ghost_scene = PackedScene.new()
	ghost_scene.pack(block)

	ghost = ghost_scene.instantiate()
	ghost.COLLIDER.queue_free() # Get rid of collider on the placeable block
	
	SHAPE_RAY.add_child(ghost)
	var ray_box : BoxShape3D = SHAPE_RAY.shape
	var block_collider : CollisionShape3D = block.COLLIDER
	var collider_shape : BoxShape3D = block_collider.shape
	ray_box.size.x = collider_shape.size.x
	
	ghost_material = ghost.MESH # Get mesh
	for child : MeshInstance3D in ghost_material.get_children():
		child.material_override = GHOST_MATERIAL
	ghost_material.material_override = GHOST_MATERIAL
	
	check_state(STATE_MACHINE.current_state.name)


func _process(_delta: float) -> void:
	if !current_buildable:
		return
	
	ghost.global_rotation = SHAPE_RAY.global_rotation
	
	handle_rotation()
		
	can_place = SHAPE_RAY.is_colliding()
	
	if !can_place:
		for child : MeshInstance3D in ghost_material.get_children():
			child.material_override = ERROR_MATERIAL
		ghost_material.material_override = ERROR_MATERIAL
		ghost.position = SHAPE_RAY.target_position + Vector3(0, -.5, 0)
		return

	var collision_distance = SHAPE_RAY.get_collision_point(0).distance_to(camera_3d.global_position)
	var ghost_position = camera_3d.global_position - camera_3d.global_basis.z * collision_distance

	# Move ghost to ray intersect position
	if can_place:
		for child : MeshInstance3D in ghost_material.get_children():
			child.material_override = GHOST_MATERIAL
		ghost_material.material_override = GHOST_MATERIAL
		ghost.global_position = ghost_position
		
func handle_rotation():
	var rot_input = Input.get_axis("rotate_R", "rotate_L")
	
	if rot_input == 0:
		z_rotation = ROTATION_INTERVAL
		return
	elif z_rotation >= ROTATION_INTERVAL:
		SHAPE_RAY.rotate_z(deg_to_rad(SNAP_ROTATION) * rot_input)
		z_rotation = 0
	else:
		z_rotation += abs(rot_input) * get_process_delta_time()
		
func hide_ghost():
	if ghost:
		ghost.hide()
		
func show_ghost():
	if ghost:
		ghost.show()
		
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
