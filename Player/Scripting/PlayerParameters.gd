extends Node


var settings_resource : PlayerSettings

var player_fullscreen : bool
var player_camera_sensitivity : float = 10
var player_camera_inverted : bool = false
var player_pitch_inverted : bool = false
var player_master_volume : float = 1
var player_tutorial_complete : bool = false

var mixer : AudioBusLayout = preload("uid://csitp8n76x4ua")

func _ready() -> void:
	load_settings()
	
	var window = get_window()
	window.size = Vector2i(DisplayServer.window_get_size().x * 2, DisplayServer.window_get_size().y * 2)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("alt"):
		save_settings()
	
	if Input.is_action_just_pressed("toggle"):
		load_settings()
	
func save_settings():
	settings_resource = PlayerSettings.new()
	
	settings_resource.player_fullscreen = player_fullscreen
	settings_resource.player_camera_sensitivity = player_camera_sensitivity
	settings_resource.player_camera_inverted = player_camera_inverted
	settings_resource.player_pitch_inverted = player_pitch_inverted
	settings_resource.player_master_volume = player_master_volume
	settings_resource.player_tutorial_complete = player_tutorial_complete

	ResourceSaver.save(settings_resource, "user://settings.tres")
	
func load_settings():
	settings_resource = load("user://settings.tres")

	if !settings_resource:
		save_settings()
		_ready()
		return

	player_fullscreen = settings_resource.player_fullscreen
	player_camera_sensitivity = settings_resource.player_camera_sensitivity
	player_camera_inverted = settings_resource.player_camera_inverted
	player_pitch_inverted = settings_resource.player_pitch_inverted
	player_master_volume = settings_resource.player_master_volume
	player_tutorial_complete = settings_resource.player_tutorial_complete
	
	set_fullscreen(player_fullscreen)
	
	set_master_volume(player_master_volume)


func set_fullscreen(toggle: bool):
	player_fullscreen = toggle
	
	if toggle:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func set_master_volume(value: float):
	player_master_volume = value

	var master_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_index, linear_to_db(value))
