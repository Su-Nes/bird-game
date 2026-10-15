extends Control

class_name WinScreen


@export var WIN_AUDIO : AudioStreamPlayer3D

func _ready() -> void:
	MenuManager.win_menu = self
	hide()

func play_win():
	WIN_AUDIO.play()

func _on_resume_pressed() -> void:
	MenuManager.on_unpaused()
	SaverLoader.game_complete = true
	SaverLoader.activate_crown(true)
	SaverLoader.save_game()
	hide()
	
func on_quit_pressed():
	MenuManager.on_quit()
