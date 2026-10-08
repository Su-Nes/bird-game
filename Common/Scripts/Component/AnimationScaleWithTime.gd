extends AnimationPlayer

class_name AnimationScaleWithTime


var start_scale

func _ready() -> void:
	start_scale = speed_scale

func _process(_delta: float) -> void:
	speed_scale = start_scale / Engine.time_scale
