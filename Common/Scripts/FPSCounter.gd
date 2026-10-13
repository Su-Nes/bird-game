extends Label

class_name FPSCounter


@export var ALWAYS_ON = false

func _physics_process(_delta: float) -> void:
	if ALWAYS_ON:
		text = "FPS: %s" % Engine.get_frames_per_second()
		return
	
	if Input.is_action_pressed("toggle"):
		text = "FPS: %s" % Engine.get_frames_per_second()
	else:
		text = ""
