extends Label

class_name FPSCounter


func _process(_delta: float) -> void:
	if Input.is_action_pressed("toggle"):
		text = "FPS: %s" % Engine.get_frames_per_second()
	else:
		text = ""
