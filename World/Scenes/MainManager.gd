extends Node3D

class_name MainManager


func _ready() -> void:
	if FileAccess.file_exists("user://save.tres"):
		SaverLoader.load_game()
