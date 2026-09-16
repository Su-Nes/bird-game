extends State

class_name FaintState


@export var CAMERA_MOVEMENT : CameraMovement

func _ready() -> void:
	StatController.has_fainted.connect(enter_faint_state)
	
func enter_faint_state():
	state_machine.change_state(name)

func enter():
	print("Entered Faint state.")
	
	CAMERA_MOVEMENT.enabled = false
	
	state_machine.ANIMATOR.play("Crash")
	MenuManager.on_faint()


	
	
