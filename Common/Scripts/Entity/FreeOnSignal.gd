extends CollisionObject3D


@export var TARGET_GROUP : String = "Player"
@export var FREEABLE : Array[Node]

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(TARGET_GROUP):
		free_nodes()

func _on_world_button_on_pressed() -> void:
	free_nodes()
	
func free_nodes():
	for node in FREEABLE:
			node.queue_free()
