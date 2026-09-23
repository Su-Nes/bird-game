extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.player_change_state.emit("SwimState")
		
	if body is Camera3D:
		print("Camera in water")


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.player_change_state.emit("IdleState")
