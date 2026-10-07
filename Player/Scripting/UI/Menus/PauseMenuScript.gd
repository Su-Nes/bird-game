extends Control

class_name PauseMenuScript


@export_category("Menu sections")
@export var CONTROLS : Control
@export var SETTINGS : Control
@export_category("Settings objects")
@export var FS_CHECK : CheckButton
@export var SENSITIVITY : HSlider
@export var CAMERA_CHECK : CheckButton
@export var PITCH_CHECK : CheckButton
@export var MASTER_VOLUME : HSlider

func _ready() -> void:
	FS_CHECK.button_pressed = PlayerParameters.player_fullscreen
	SENSITIVITY.value = PlayerParameters.player_camera_sensitivity
	CAMERA_CHECK.button_pressed = PlayerParameters.player_camera_inverted
	PITCH_CHECK.button_pressed = PlayerParameters.player_pitch_inverted
	MASTER_VOLUME.value = PlayerParameters.player_master_volume
	
	MenuManager.pause_menu = self
	MenuManager.on_unpaused()

func _on_resume_pressed() -> void:
	MenuManager.on_unpaused()

func _on_quit_pressed() -> void:
	#SaverLoader.save_game()
	PlayerParameters.save_settings()
	get_tree().quit()

func _on_reload_pressed() -> void:
	MenuManager.on_revive()
	
var control_toggle = false
func _on_toggle_controls_pressed() -> void:
	control_toggle = !control_toggle
	if control_toggle:
		CONTROLS.show()
		SETTINGS.hide()
	else:
		CONTROLS.hide()
		SETTINGS.show()

func _on_fs_check_toggled(toggled_on: bool) -> void:
	PlayerParameters.set_fullscreen(toggled_on)

func _on_h_slider_value_changed(value: float) -> void:
	PlayerParameters.player_camera_sensitivity = value
	
func _on_camera_check_toggled(toggled_on: bool) -> void:
	PlayerParameters.player_camera_inverted = toggled_on

func _on_pitch_check_toggled(toggled_on: bool) -> void:
	PlayerParameters.player_pitch_inverted = toggled_on

func _on_volume_slider_value_changed(value: float) -> void:
	PlayerParameters.set_master_volume(value)
