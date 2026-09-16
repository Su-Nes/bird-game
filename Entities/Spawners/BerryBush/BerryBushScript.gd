extends StaticBody3D

class_name BerryBush

@export var RAYCAST : RayCast3D
@export var BERRY : PackedScene
@export var SPAWN_TIME : Vector2
@export var SPAWN_GROUP : Vector2
@export var SPAWN_DISTANCE : float = 1.5

var spawn_time : float
var spawn_timer : float


func _ready() -> void:
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
		var rand_pos = global_position + Vector3(randf_range(-1, 1), randf(), randf_range(-1, 1)).normalized() * SPAWN_DISTANCE
		#var ray_start = global_position + Vector3(randf() * 2 - 1, randf(), randf() * 2 - 1).normalized() * 2
		#RAYCAST.look_at_from_position(ray_start, global_position)
		#print("position: %s; rotation: %s; n: %s" % [RAYCAST.position, RAYCAST.rotation, n])
		#DebugDraw3D.draw_line(RAYCAST.global_position, RAYCAST.global_position + -RAYCAST.global_basis.z * 2, Color.PINK, 1)
		#DebugDraw3D.draw_sphere(rand_pos, .1, Color.BLUE, 1)
		var new_berry : RigidBody3D = BERRY.instantiate()
		add_child(new_berry)
		new_berry.global_position = rand_pos
