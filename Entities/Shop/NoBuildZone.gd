extends Area3D

class_name NoBuildZone


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.building_enabled = false

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.building_enabled = true
		
