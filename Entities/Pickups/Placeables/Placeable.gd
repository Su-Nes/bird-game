extends Interactable

class_name Placeable


var colliders : Array
var forward_connections : Array[Placeable]
var backwards_connections : Array[Placeable]
@export var COLLISION_SEARCH_MARGIN : float = 1.5

func on_focus():
	var tip_kb : Dictionary[Texture2D, String] = {GRAB_ICON_KB : GRAB_TOOL_TIP}
	var tip_gp : Dictionary[Texture2D, String] = {GRAB_ICON_GP : GRAB_TOOL_TIP}

	Signals.display_tool_tips.emit(tip_kb, tip_gp, String.num_int64(interaction_tip_index))

func on_placed():
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
			
func on_selected():
	super.on_selected()
	
	Signals.build_controller.initiate_building(self)
	
func on_unselected():
	super.on_unselected()

	Signals.build_controller.stop_building()

func on_use():
	return false if Signals.build_controller.place() else true
	
func on_grabbed():
	#print(forward_connections)
	propogate_stability(true, self)
	
func get_colliders(): # This is quite stupid but it works
	if !COLLIDER:
		return
	
	var area = Area3D.new()
	var area_col = CollisionShape3D.new()
	area.add_child(area_col)
	
	area_col.owner = area
	area_col.shape = COLLIDER.shape
	area_col.scale *= COLLISION_SEARCH_MARGIN
	
	var area_scene = PackedScene.new()
	area_scene.pack(area)
	
	var new_area = area_scene.instantiate()
	add_child(new_area)
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	colliders = new_area.get_overlapping_bodies()
	colliders.erase(self)
	
	new_area.queue_free()
	
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
