extends Node3D

class_name Interactable


@export var IS_GRABBABLE = true
@export var GRAB_ONLY = false
var is_grabbed = false

@export var COLLIDER : CollisionShape3D
@export var RIGIDBODY : RigidBody3D


var interaction_tip_index = 0
var selection_tip_index = 0


func _ready() -> void:
	interaction_tip_index = randi()
	selection_tip_index = randi()

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
	
func has_physics(collider_active : bool, rb_active : bool):
	if COLLIDER:
		COLLIDER.disabled = !collider_active
	if RIGIDBODY:
		RIGIDBODY.freeze = !rb_active
