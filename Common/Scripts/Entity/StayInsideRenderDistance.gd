extends Node3D

class_name StayInsideRenderDistance


@export var DISTANCE_MARGIN : float = 50

var start_pos : Vector3
var player : Node3D

func _ready() -> void:
	start_pos = global_position
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(_delta: float) -> void:
	if global_position.distance_to(player.global_position) > PlayerParameters.player_render_distance:
		var vector_from_player = global_position - player.global_position
		vector_from_player.y = start_pos.y
		
		global_position = player.global_position + vector_from_player.normalized() * (PlayerParameters.player_render_distance - DISTANCE_MARGIN)
		global_position.y = start_pos.y
	else:
		global_position = start_pos
