extends WingState

class_name WingsFlapping


func enter():
	print("Wings entered Flap state.")
	
	state_machine_wing.ANIMATOR.play("Hovering")


func exit():
	state_machine_wing.ANIMATOR.stop()
