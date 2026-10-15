extends Node3D

class_name AreaSpawner

@export var SPAWN_AREA : CollisionShape3D
var spawn_box : BoxShape3D
@export var SPAWNABLE : PackedScene
@export var OBJECT_HOLDER : Node3D
@export var SPAWN_TIME : Vector2
@export var SPAWN_GROUP : Vector2
@export var MAX_SPAWNED : int = 15

var spawn_time : float
var spawn_timer : float

var player : Node3D
var SPAWN_DISTANCE : float = 150

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	
	spawn_box = SPAWN_AREA.shape
	spawn_nodes()
	
func reset_timer():
	spawn_timer = 0
	spawn_time = randf_range(SPAWN_TIME.x, SPAWN_TIME.y)

func _process(delta: float) -> void:
	if player.global_position.distance_to(global_position) > SPAWN_DISTANCE:
		#if OBJECT_HOLDER.get_child_count() > 0:
			#free_nodes()
		return
	
	if spawn_timer < spawn_time:
		spawn_timer += delta
	else:
		spawn_nodes()
		reset_timer()

func spawn_nodes():
	var group_size = randi_range(roundi(SPAWN_GROUP.x), roundi(SPAWN_GROUP.y))

	for n in group_size:
		if OBJECT_HOLDER.get_child_count() >= MAX_SPAWNED:
			return
		
		var rand_pos = Vector3(randf_range(-spawn_box.size.x, spawn_box.size.x), randf_range(-spawn_box.size.x, spawn_box.size.y), randf_range(-spawn_box.size.x, spawn_box.size.z))
		
		var new_node : Node3D = SPAWNABLE.instantiate()
		OBJECT_HOLDER.add_child(new_node)
		new_node.global_position = SPAWN_AREA.global_position + rand_pos
		
func free_nodes():
	for node in OBJECT_HOLDER.get_children():
		node.queue_free()
