extends WingState

class_name WingsFlapping


@export var ANIMATOR : AnimationPlayer

func enter():
	print("Wings entered Flap state.")
	
	ANIMATOR.play("Flapping")


func exit():
	ANIMATOR.stop()
