extends Interactable

class_name Placeable

@export var test_subject = false
var colliders : Array[Variant]
var col_count
var is_stable


func _enter_tree() -> void:
	print(name)


func on_focus():
	var tip_kb : Dictionary[Texture2D, String] = {GRAB_ICON_KB : GRAB_TOOL_TIP}
	var tip_gp : Dictionary[Texture2D, String] = {GRAB_ICON_GP : GRAB_TOOL_TIP}

	Signals.display_tool_tips.emit(tip_kb, tip_gp, String.num_int64(interaction_tip_index))


func on_grabbed(sender = null):
	_enter_tree()
	for placable in colliders:
		if placable is Placeable and placable != sender:
			placable.on_grabbed(self)

func on_placed():
	on_grabbed()

func on_selected():
	super.on_selected()
	
	Signals.build_controller.initiate_building(self)
	
func on_unselected():
	super.on_unselected()

	Signals.build_controller.stop_building()

func on_use():
	return false if Signals.build_controller.place() else true
		
func get_colliders(): # MWUAHAHAHAHAHAHAAAA
	if !COLLIDER:
		return
	
	var area = Area3D.new()
	var area_col = CollisionShape3D.new()
	area.add_child(area_col)
	
	area_col.owner = area
	area_col.shape = COLLIDER.shape
	area_col.scale *= 1.1
	
	var area_scene = PackedScene.new()
	area_scene.pack(area)
	
	var new_area = area_scene.instantiate()
	add_child(new_area)
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	colliders = new_area.get_overlapping_bodies()
	colliders.erase(self)
		
		
func check_stability(sender = null) -> bool:
	if is_grabbed:
		return true
	
	await get_colliders()
		
	#print("triggered %s with %s" % [name, colliders])

	for collider in colliders:
		if collider is Placeable:
			if collider != sender:
				#print("checking %s" % collider.name)
				if !await collider.check_stability(self):
					continue
				return true
			else:
				#print("%s was sender" % sender)
				continue
		else:
			#print("found static body %s on %s for %s" % [collider, name, sender])
			return true
	#print("%s ran out of colliders" % name)
	return false
