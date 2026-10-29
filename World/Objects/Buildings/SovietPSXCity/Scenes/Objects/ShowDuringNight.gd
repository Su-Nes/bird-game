extends Node3D


func _ready() -> void:
	Signals.time_controller.evening.connect(show)
	Signals.time_controller.morning.connect(hide)
