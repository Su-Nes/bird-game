extends WingState

class_name WingsIdle

@export var ANIMATOR_ALT : AnimationPlayer
@export var IDLE_LERP : float


func enter():
	ANIMATOR_ALT.play("RESET", 1)
		
#func physics_update(_delta: float):
	# Move wings to idle state
	#state_machine_wing.WING_L.position = lerp(state_machine_wing.WING_L.position, state_machine_wing.idle_position_l, IDLE_LERP)
	#state_machine_wing.WING_R.position = lerp(state_machine_wing.WING_R.position, state_machine_wing.idle_position_r, IDLE_LERP)
	#
	#state_machine_wing.WING_L.rotation = lerp(state_machine_wing.WING_L.rotation, state_machine_wing.idle_rotation_l, IDLE_LERP)
	#state_machine_wing.WING_R.rotation = lerp(state_machine_wing.WING_R.rotation, state_machine_wing.idle_rotation_r, IDLE_LERP)
