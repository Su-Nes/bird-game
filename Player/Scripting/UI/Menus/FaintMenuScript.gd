extends Control

class_name FaintMenuScript


@export var LOAD_TUTORIAL_BUTTON : Control
@export var LEAVE_TUTORIAL_BUTTON : Control

func _ready() -> void:
	MenuManager.faint_menu = self
	hide()

func _on_resume_pressed() -> void:
	MenuManager.on_revive()

func _on_quit_pressed() -> void:
	SaverLoader.save_game()
	PlayerParameters.save_settings()
	get_tree().quit()
