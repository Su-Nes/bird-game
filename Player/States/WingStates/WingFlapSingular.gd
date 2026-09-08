extends WingState

class_name WingsFlapSingular


func enter():
	print("Wings entered Flap state.")
	
	state_machine_wing.ANIMATOR.play("Flap")
	await state_machine_wing.ANIMATOR.animation_finished
	state_machine_wing.ANIMATOR.play("Glide")
	state_machine_wing.change_state("wingsGliding")
