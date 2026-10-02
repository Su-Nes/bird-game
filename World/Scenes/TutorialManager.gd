extends Node3D

class_name TutorialManager


@export var SPAWN_POS := Vector3(0, 1, 0)
@export var NEST : NestManager
@export var NEXT_SCENE : PackedScene

func _ready() -> void:
	StatController.max_stamina_reached.connect(load_next_scene)
	StatController.drain_enabled = false
	
	if NEST:
		NEST.decor_target_reached.connect(load_next_scene)

func _on_player_reset_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var player : Node3D = body
		player.global_position = SPAWN_POS
		
func _on_player_reset_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var player : Node3D = body
		player.global_position = SPAWN_POS

func _on_stamina_drain_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		StatController.drain_enabled = true
		StatController.spend_max_stamina(StatController.MAX_BASE_STAMINA / 4)
		StatController.drain_enabled = false
		

func load_next_scene():
	get_tree().change_scene_to_packed(NEXT_SCENE) # TO-DO: Make proper scene load and save system

# Tutorial part 2
func _on_player_bounds_body_entered(_body: Node3D) -> void:
	if StatController.max_stamina_reached.is_connected(load_next_scene):
		StatController.max_stamina_reached.disconnect(load_next_scene)
	StatController.drain_enabled = true
	
func _on_player_bounds_body_exited(body: Node3D) -> void:
	_on_player_reset_body_entered(body)
