extends Control

class_name PauseMenuScript


func _ready() -> void:
	MenuManager.pause_menu = self
	MenuManager.on_paused()


func _on_resume_pressed() -> void:
	MenuManager.on_unpaused()


func _on_quit_pressed() -> void:
	get_tree().quit()
