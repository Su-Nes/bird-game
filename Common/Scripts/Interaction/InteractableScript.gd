extends Node3D

class_name Interactable


@export var IS_GRABBABLE = true
@export var GRAB_ONLY = false
@export var GRAB_IS_INTERACT = false
var is_grabbed = false

@export var BEAK_ANGLE_MOD : float = 0

@export var MESH : MeshInstance3D
@export var COLLIDER : CollisionShape3D
@export var RIGIDBODY : RigidBody3D

var interaction_tip_index = 0
var selection_tip_index = 0

@export var is_placed = false


func _ready() -> void:
	interaction_tip_index = randi()
	selection_tip_index = randi()
	
	if MESH:
		return
	
	for n in get_children():
		if n is MeshInstance3D:
			MESH = n
			break

func on_focus():
	pass
	
func on_lose_focus():
	pass
	
func on_interact():
	pass
	
func on_interact_alt():
	pass
	
func on_selected():
	pass
	
func on_unselected():
	pass
	
func on_use() -> bool: ##Returns false if interactable is freed after interaction
	return true
	
func on_grabbed():
	pass
	
func on_dropped():
	pass
	
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
	
func has_physics(collider_active : bool, rb_active : bool):
	if COLLIDER:
		COLLIDER.disabled = !collider_active
	if RIGIDBODY:
		RIGIDBODY.freeze = !rb_active
