extends Edible

class_name Shit


var landed = false

func _ready() -> void:
	RIGIDBODY.contact_monitor = true
	RIGIDBODY.max_contacts_reported = 9

func _on_body_entered(_body: Node) -> void:
	has_physics(true, false)
	
