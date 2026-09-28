extends RayCast3D

class_name RaycastSpawner


@export var SPAWNABLE_NODE : PackedScene
@export var RADIUS : float = 10
@export_range(0, 1) var CHANCE_TO_TRIGGER : float = .075
@export var RAND_COUNT : Vector2 = Vector2(1, 3)
@export var RAND_ROTATION = true

func _ready() -> void:
	await get_tree().create_timer(.1).timeout

	reparent(get_tree().root)

	if randf() > CHANCE_TO_TRIGGER:
		return
		
	var spawn_count = randi_range(roundi(RAND_COUNT.x), roundi(RAND_COUNT.y))
	
	for n in spawn_count:
		spawn_object()
		
	#queue_free()


func spawn_object():
	# TO-DO: Make spawned object align with normal
	global_position += Vector3(randf_range(-RADIUS, RADIUS), 0, randf_range(-RADIUS, RADIUS))
	
	if !is_colliding():
		return
	print(get_collider().get_class())
	var new_scene : Node3D = SPAWNABLE_NODE.instantiate()
	get_tree().root.add_child(new_scene)
	DebugDraw3D.draw_line(global_position, global_position + global_basis.y * target_position.y, Color.BLUE, 60)
	new_scene.global_position = get_collision_point()
	
	new_scene.rotate_y(2 * PI * randf())
