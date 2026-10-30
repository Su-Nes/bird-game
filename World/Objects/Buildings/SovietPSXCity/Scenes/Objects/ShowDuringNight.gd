extends Node3D


@export var RANDOM_DELAY : float = 2

func _ready() -> void:
	Signals.time_controller.evening.connect(delayed_show)
	Signals.time_controller.morning.connect(delayed_hide)
	

func delayed_show():
	await get_tree().create_timer(RANDOM_DELAY * randf()).timeout
	show()
	
func delayed_hide():
	await get_tree().create_timer(RANDOM_DELAY * randf()).timeout
	hide()
