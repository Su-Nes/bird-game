extends Node3D


@export var MOVEMENT : Vector3 = Vector3.UP
@export var LIFETIME : float = 1

var timer : float

func _process(delta: float) -> void:
	translate(MOVEMENT * delta)
	
	timer += delta
	
	if timer >= LIFETIME:
		queue_free()
