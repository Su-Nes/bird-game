extends Node

class_name GrabScript


@export var GRAB_POINT : Marker3D
@export var DROP_OFFSET : Vector3
@export var BEAK_TOP : Node3D
@export var BEAK_BOTTOM : Node3D
@export_category("Storage settings")
@export var MAX_ITEMS : int = 5
@export var BREAK_ROT_PER_ITEM : int = 10

var active_index = 0

func grab_item(item: Interactable):
	if GRAB_POINT.get_child_count() >= MAX_ITEMS:
		print("Too many items!")
		return
	
	item.reparent(GRAB_POINT)
	item.is_grabbed = true
	item.on_grabbed()
	item.has_physics(false, false)
	item.reparent(GRAB_POINT)

	item.position = Vector3.ZERO
	item.rotation = Vector3.ZERO
	
	active_index = GRAB_POINT.get_child_count() - 1
	
	display_active_item()
	
func _process(_delta: float) -> void:	
	handle_beak_rotation()
	
	if GRAB_POINT.get_child_count() <= 0:
		return
	
	if Input.is_action_just_pressed("drop"):
		remove_selected_item(true)
		display_active_item()
		
	if Input.is_action_just_pressed("scroll_plus"):
		active_index += 1
		if active_index >= GRAB_POINT.get_child_count():
			active_index = 0
		display_active_item()
		
	if Input.is_action_just_pressed("scroll_minus"):
		active_index -= 1
		if active_index < 0:
			active_index = GRAB_POINT.get_child_count() - 1
		display_active_item()


func use_item():
	if GRAB_POINT.get_child_count() <= 0:
		return
		
	var count_before = GRAB_POINT.get_child_count()
		
	var item : Interactable = GRAB_POINT.get_child(active_index)
	item.on_use()
	
	await get_tree().process_frame
	
	if count_before != GRAB_POINT.get_child_count():
		active_index = GRAB_POINT.get_child_count() - 1
	
	display_active_item()

func display_active_item():
	var index = 0
	for n : Interactable in GRAB_POINT.get_children():
		if index != active_index:
			n.visible = false
			n.on_unselected()
		index += 1
	
	if GRAB_POINT.get_child_count() > 0:
		var active_child : Interactable = GRAB_POINT.get_child(active_index)
		active_child.visible = true
		active_child.on_selected()

func unselect_all():
	for n : Interactable in GRAB_POINT.get_children():
		n.on_unselected()
	
func remove_selected_item(drop_physically = false):
	var item : Interactable = GRAB_POINT.get_child(-1)

	item.reparent(get_tree().root)
	item.is_grabbed = false
	item.on_unselected()

	display_active_item()
	
	if !drop_physically:
		return
	
	item.global_position = item.global_position - $"../MeshHandle".global_basis.z * DROP_OFFSET.z + Vector3.UP * DROP_OFFSET.y
	
	item.has_physics(true, true)
	
func handle_beak_rotation():
	BEAK_TOP.rotation.x = 0
	BEAK_BOTTOM.rotation.x = 0
	#TO-DO: Have seperate rotation values for each item.
	if GRAB_POINT.get_child_count() > 0:
		BEAK_TOP.rotate_x(deg_to_rad(BREAK_ROT_PER_ITEM) / 2)
		BEAK_BOTTOM.rotate_x(deg_to_rad(-BREAK_ROT_PER_ITEM) / 2)
