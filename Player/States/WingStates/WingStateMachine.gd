extends StateMachine

class_name WingStateMachine


@export var WING_L : Node3D
@export var WING_R: Node3D

var idle_position_l : Vector3
var idle_position_r : Vector3

var idle_rotation_l : Vector3
var idle_rotation_r : Vector3

func _ready() -> void:
	super()

	idle_position_l = WING_L.position
	idle_position_r = WING_R.position

	idle_rotation_l = WING_L.rotation
	idle_rotation_r = WING_R.rotation
	
	# Register wing state machine in children
	for child in get_children():
		if child is WingState:
			child.state_machine_wing = self
