extends State

class_name BugGrabbed

@onready var bug : Node3D = $"../.."
@export var ANIM_SPEED : float = 5

func enter():
	state_machine.ANIMATOR.play("Bug", -1, ANIM_SPEED)
	
	bug.rotate_y(PI / 2)
	
