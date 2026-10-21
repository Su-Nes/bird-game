extends Node3D

class_name NestArrows


@export var ARROW : PackedScene = preload("uid://3th0h40j1t4a")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle"):
		show_arrows()
		
	if Input.is_action_just_released("toggle"):
		hide_arrows()
		
func show_arrows():
	for nest : Node3D in get_tree().get_nodes_in_group("Nest"):
		if nest.global_position.distance_to(global_position) < PlayerParameters.player_render_distance:
			continue
		
		var new_arrow : LookAt = ARROW.instantiate()
		add_child(new_arrow)
		
		new_arrow.TARGET = nest
	
func hide_arrows():
	for arrow in get_children():
		arrow.queue_free()
