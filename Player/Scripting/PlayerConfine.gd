extends Area3D

class_name PlayerConfine


@export var REVERSE_FORCE : float = 50
@export var LOST_AND_FOUND_SPAWN : Marker3D

func on_exit_confine(body: Node3D):
	if body.is_in_group("Player"):
		var controller : CharacterBody3D = body
		
		controller.velocity = Vector3.ZERO
		controller.velocity.y += REVERSE_FORCE * 2.5 if controller.global_position.y < 0 else -REVERSE_FORCE

		Signals.player_change_state.emit("FlyState")
	elif body is Interactable:
		if body.is_grabbed:
			return
		body.linear_velocity = Vector3.ZERO
		body.global_position = LOST_AND_FOUND_SPAWN.global_position
