extends Control

class_name FaintMenuScript


func _ready() -> void:
	MenuManager.faint_menu = self
	hide()


func _on_resume_pressed() -> void:
	MenuManager.on_revive()


func _on_quit_pressed() -> void:
	SaverLoader.save_game()
	PlayerParameters.save_settings()
	get_tree().quit()
