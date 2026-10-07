extends CanvasLayer


signal loading_screen_ready

@export var ANIMATOR : AnimationPlayer

func _ready() -> void:
	await ANIMATOR.animation_finished
	loading_screen_ready.emit()
	
func on_progress_changed(new_value: float):
	pass
	
func on_load_finished():
	ANIMATOR.play_backwards("Transition")
	await ANIMATOR.animation_finished
	queue_free()
