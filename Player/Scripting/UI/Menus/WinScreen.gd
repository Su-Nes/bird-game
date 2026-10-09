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
	hide()
	
func on_quit_pressed():
	MenuManager.on_quit()
