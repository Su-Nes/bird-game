extends Label


func _process(_delta: float) -> void:
	text = "seeds: %s" % StatController.seeds
