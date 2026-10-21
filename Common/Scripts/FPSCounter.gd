extends Label

class_name FPSCounter


@export var ALWAYS_ON = false

func _physics_process(_delta: float) -> void:
	text = "FPS: %s" % Engine.get_frames_per_second()
	
	if ALWAYS_ON:
		show()
		return
		
	if Input.is_action_pressed("toggle"):
		show()
	else:
		hide()
