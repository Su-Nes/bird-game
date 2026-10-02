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


func _ready() -> void:
	spawn_box = SPAWN_AREA.shape
	
	spawn_timer = 0
	spawn_time = randf_range(SPAWN_TIME.x, SPAWN_TIME.y)
	
	spawn_nodes()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_timer < spawn_time:
		spawn_timer += delta
	else:
		spawn_nodes()
		
		_ready()

func spawn_nodes():
	var group_size = randi_range(roundi(SPAWN_GROUP.x), roundi(SPAWN_GROUP.y))

	for n in group_size:
		if OBJECT_HOLDER.get_child_count() >= MAX_SPAWNED:
			return
		
		var rand_pos = Vector3(randf_range(-spawn_box.size.x, spawn_box.size.x), randf_range(-spawn_box.size.x, spawn_box.size.y), randf_range(-spawn_box.size.x, spawn_box.size.z))
		
		var new_berry : Node3D = SPAWNABLE.instantiate()
		OBJECT_HOLDER.add_child(new_berry)
		new_berry.global_position = SPAWN_AREA.global_position + rand_pos
