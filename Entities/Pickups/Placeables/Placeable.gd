extends Interactable

class_name Placeable


var colliders : Array
var forward_connections : Array[Placeable]
var backwards_connections : Array[Placeable]
@export var DECOR_VALUE : int = 1
@export var COLLISION_SEARCH_MARGIN : float = 1.5
@export var PLACEABLE_DETECTION_AREA : PackedScene = preload("uid://2ql1yen4toui")
var MINIMUM_PLACED_OBJECTS_FOR_NEST := 5
@export var NEST_PROMPT : PackedScene = preload("uid://bwmqd5nb80in3")

var detection_area : Area3D
@export var is_placed = false


func _ready() -> void:
	if RIGIDBODY:
		RIGIDBODY.freeze = true

func on_save_data(saved_data: Array[SavedData]):
	var data = SavedData.new()
	
	var self_scene = PackedScene.new()
	self_scene.pack(self)
	
	data.scene = self_scene
	data.tf = transform
	data.parent_path = get_parent().get_path()
	data.is_grabbed = get_parent().name == "GrabPoint"
	data.is_placed = is_placed
	
	saved_data.append(data)
	
func on_loaded(data: SavedData):
	transform = data.tf
	is_placed = data.is_placed

	if data.is_grabbed && !is_inside_tree():
		has_physics(false, false)
		Signals.grab_item.emit(self)
		
		return
	
	handle_colliders()

func on_placed():
	is_placed = true
	
	handle_colliders()
	create_detection_area()
	
	await get_tree().physics_frame
	
	detect_nest()
	
func handle_colliders():
	await get_colliders()
	
	if colliders.size() < 1:
		has_physics(true, true)
		return
	
	var touching_static = false
	for col in colliders:
		if col is StaticBody3D:
			touching_static = true
			break

	for col in colliders:
		if col is Placeable:
			if touching_static:
				col.backwards_connections.append(self)
				forward_connections.append(col)
			else:
				col.forward_connections.append(self)
				backwards_connections.append(col)
			
func create_detection_area():
	if !detection_area:
		detection_area = PLACEABLE_DETECTION_AREA.instantiate()
		add_child(detection_area)


func detect_nest():
	var placed_object_count = 0
	
	await get_tree().physics_frame
	
	for body in detection_area.get_overlapping_bodies():
		if body is Placeable:
			if body.is_placed:
				placed_object_count += 1
				
	if placed_object_count >= MINIMUM_PLACED_OBJECTS_FOR_NEST:
		prompt_for_nest()
	
func prompt_for_nest():
	if await get_colliders():
		return
	
	var new_nest : Node3D = NEST_PROMPT.instantiate()
	get_tree().root.add_child(new_nest)
	
	new_nest.global_position = global_position
	
func on_selected():
	super.on_selected()
	
	Signals.build_controller.initiate_building(self)
	
func on_unselected():
	super.on_unselected()

	Signals.build_controller.stop_building()

func on_use():
	return false if Signals.build_controller.place() else true
	
func on_grabbed():
	propogate_stability(true, self)
	
func get_colliders() -> bool: ## Returns true if this object is in a nest area
	if !COLLIDER:
		return false
	
	var area = Area3D.new()
	var area_col = CollisionShape3D.new()
	area.add_child(area_col)
	
	area_col.owner = area
	area_col.shape = COLLIDER.shape
	area_col.scale *= COLLISION_SEARCH_MARGIN
	
	var area_scene = PackedScene.new()
	area_scene.pack(area)
	
	var new_area : Area3D = area_scene.instantiate()
	add_child(new_area)
	
	if !is_inside_tree():
		return false
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	colliders = new_area.get_overlapping_bodies()
	colliders.erase(self)
	
	for a in new_area.get_overlapping_areas():
		if a is NestManager:
			new_area.queue_free()
			return true
	
	new_area.queue_free()
	return false
	
func propogate_stability(is_root_call : bool, previous_branch: Placeable):
	#print("backward connections: %s" % backwards_connections)
	if !is_root_call and backwards_connections.size() < 2:
		has_physics(true, true)
		
	if backwards_connections.size() > 1:
		backwards_connections.erase(previous_branch)
		return
	
	if forward_connections.size() < 1:
		clear_connections()
		return
	
	var forward_connections_dupe = forward_connections.duplicate()
	for obj in forward_connections_dupe:
		obj.propogate_stability(false, self)
		
	clear_connections()

func clear_connections():
	forward_connections.clear()
	
	for connection in backwards_connections:
		var forward_index = 0
		for forward in connection.forward_connections:
			if forward.name == self.name:
				connection.forward_connections.remove_at(forward_index)
			forward_index += 1
		
	backwards_connections.clear()
