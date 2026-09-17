extends WingState

class_name WingsFlapping


func enter():
	state_machine_wing.ANIMATOR.play("Hovering")


func exit():
	state_machine_wing.ANIMATOR.stop()
