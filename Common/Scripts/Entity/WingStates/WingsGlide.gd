extends WingState

class_name WingsGliding


@export var WING_ROTATION_DIST : Vector3
@export var GLIDE_LERP : float

var target_rotation_l : Vector3
var target_rotation_r : Vector3

func enter():
	print("Wings entered Glide state.")
	
	target_rotation_l.x = state_machine_wing.idle_rotation_l.x + deg_to_rad(WING_ROTATION_DIST.x)
	target_rotation_l.y = state_machine_wing.idle_rotation_l.y + deg_to_rad(WING_ROTATION_DIST.y)
	target_rotation_l.z = state_machine_wing.idle_rotation_l.z + deg_to_rad(WING_ROTATION_DIST.z)
	
	target_rotation_r.x = state_machine_wing.idle_rotation_r.x - deg_to_rad(WING_ROTATION_DIST.x)
	target_rotation_r.y = state_machine_wing.idle_rotation_r.y - deg_to_rad(WING_ROTATION_DIST.y)
	target_rotation_r.z = state_machine_wing.idle_rotation_r.z - deg_to_rad(WING_ROTATION_DIST.z)


func physics_update(_delta: float):
	# Move wings to glide state
	state_machine_wing.WING_L.rotation = lerp(state_machine_wing.WING_L.rotation, target_rotation_l , GLIDE_LERP)
	state_machine_wing.WING_R.rotation = lerp(state_machine_wing.WING_R.rotation, target_rotation_r, GLIDE_LERP)
