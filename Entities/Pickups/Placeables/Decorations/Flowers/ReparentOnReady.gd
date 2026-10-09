extends Node

class_name ReparentOnReady


@export var TARGET : Node

func _process(_delta: float) -> void:
	if get_parent() == TARGET:
		return
	
	if !TARGET:
		TARGET = get_tree().root
		
	reparent(TARGET)
