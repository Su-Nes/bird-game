extends Control

class_name PauseMenuScript


@export_category("Menu sections")
@export var CONTROLS : Control
@export var SETTINGS : Control
@export var LOAD_TUTORIAL_BUTTON : Control
@export var LEAVE_TUTORIAL_BUTTON : Control
@export_category("Settings objects")
@export var FS_CHECK : CheckButton
@export var SENSITIVITY : HSlider
@export var CAMERA_CHECK : CheckButton
@export var PITCH_CHECK : CheckButton
@export var MASTER_VOLUME : HSlider
@export_category("Start menu")
@export var START_PAUSED = false
@export var TUTORIAL_SCENE : String = "uid://bcvd02sw2vjl"
@export var MAIN_SCENE : String = "uid://gyv0w2cpssjs"

func _ready() -> void:
	FS_CHECK.button_pressed = PlayerParameters.player_fullscreen
	SENSITIVITY.value = PlayerParameters.player_camera_sensitivity
	CAMERA_CHECK.button_pressed = PlayerParameters.player_camera_inverted
	PITCH_CHECK.button_pressed = PlayerParameters.player_pitch_inverted
	MASTER_VOLUME.value = PlayerParameters.player_master_volume
	
	MenuManager.pause_menu = self
	if START_PAUSED:
		MenuManager.on_paused()
	else:
		MenuManager.on_unpaused()
		
	if !LOAD_TUTORIAL_BUTTON or !LEAVE_TUTORIAL_BUTTON:
		return

	if get_tree().current_scene.name == "Tutorial":
		LOAD_TUTORIAL_BUTTON.hide()
		LEAVE_TUTORIAL_BUTTON.show()
	else:
		LOAD_TUTORIAL_BUTTON.show()
		LEAVE_TUTORIAL_BUTTON.hide()

func _on_start_game_pressed() -> void:
	if FileAccess.file_exists("user://save.tres"):
		SceneLoader.load_scene(MAIN_SCENE)
	else:
		SceneLoader.load_scene(TUTORIAL_SCENE)

func _on_resume_pressed() -> void:
	MenuManager.on_unpaused()
	
func _on_quit_pressed() -> void:
	MenuManager.on_quit()

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


func _on_load_tutorial_pressed() -> void:
	if get_tree().current_scene.name == "Main":
		SaverLoader.save_game()
	SceneLoader.load_scene(TUTORIAL_SCENE)

func _on_leave_tutorial_pressed() -> void:
	SceneLoader.load_scene(MAIN_SCENE)
