extends Node3D

class_name Interactable


@export var IS_GRABBABLE = true
@export var GRAB_ONLY = false
var is_grabbed = false

@export var INTERACT_ICON_KB : Texture2D = preload("uid://d2urtulen2r5e")
@export var INTERACT_ICON_GP : Texture2D = preload("uid://dv1v8uwer037r")
@export var INTERACT_TOOL_TIP : String = ": Eat"
@export var GRAB_ICON_KB : Texture2D = preload("uid://dfvlenwxjvaf6")
@export var GRAB_ICON_GP : Texture2D = preload("uid://c3htawr76oyk4")
@export var GRAB_TOOL_TIP : String = ": Grab"
@export var SELECTED_TOOL_TIP : String = ": Place"
@export var COLLIDER : CollisionShape3D
@export var RIGIDBODY : RigidBody3D

var dic_tip_kb : Dictionary[Texture2D, String] = {GRAB_ICON_KB : GRAB_TOOL_TIP, INTERACT_ICON_KB : INTERACT_TOOL_TIP}
var dic_tip_gp : Dictionary[Texture2D, String] = {GRAB_ICON_GP : GRAB_TOOL_TIP, INTERACT_ICON_GP : INTERACT_TOOL_TIP}

var interaction_tip_index = 0
var selection_tip_index = 0


func _ready() -> void:
	interaction_tip_index = randi()
	selection_tip_index = randi()

func on_focus():
	Signals.display_tool_tips.emit(dic_tip_kb, dic_tip_gp, String.num_int64(interaction_tip_index))

func on_lose_focus():
	Signals.remove_tool_tips.emit(String.num_int64(interaction_tip_index))
	
func on_interact():
	pass
	
func on_interact_alt():
	pass
	
func on_selected():
	var selected_tip_kb : Dictionary[Texture2D, String] = {INTERACT_ICON_KB : SELECTED_TOOL_TIP}
	var selected_tip_gp : Dictionary[Texture2D, String] = {INTERACT_ICON_GP : SELECTED_TOOL_TIP}

	Signals.display_tool_tips.emit(selected_tip_kb, selected_tip_gp, String.num_int64(selection_tip_index))
	
func on_unselected():
	Signals.remove_tool_tips.emit(String.num_int64(selection_tip_index))
	
func on_use() -> bool: ##Returns false if interactable is freed after interaction
	return true
	
func on_grabbed():
	pass
	
func has_physics(collider_active : bool, rb_active : bool):
	if COLLIDER:
		COLLIDER.disabled = !collider_active
	if RIGIDBODY:
		RIGIDBODY.freeze = !rb_active
