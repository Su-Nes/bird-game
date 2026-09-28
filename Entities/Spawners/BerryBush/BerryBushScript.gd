extends Node3D

class_name BerryBush

@export var SPAWN_AREA : CollisionShape3D
var spawn_box : BoxShape3D
@export var BERRY : PackedScene
@export var SPAWN_TIME : Vector2
@export var SPAWN_GROUP : Vector2
@export var SPAWN_DISTANCE : float = 1.5

var spawn_time : float
var spawn_timer : float


func _ready() -> void:
	spawn_box = SPAWN_AREA.shape
	
	spawn_timer = 0
	spawn_time = randf_range(SPAWN_TIME.x, SPAWN_TIME.y)
	
	spawn_berries()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawn_timer < spawn_time:
		spawn_timer += delta
	else:
		spawn_berries()
		
		_ready()

func spawn_berries():
	var group_size = randi_range(roundi(SPAWN_GROUP.x), roundi(SPAWN_GROUP.y))

	for n in group_size:
		var rand_pos = Vector3(randf_range(-spawn_box.size.x, spawn_box.size.x), randf_range(-spawn_box.size.x, spawn_box.size.y), randf_range(-spawn_box.size.x, spawn_box.size.z))
		
		var new_berry : Node3D = BERRY.instantiate()
		add_child(new_berry)
		new_berry.global_position = SPAWN_AREA.global_position + rand_pos
