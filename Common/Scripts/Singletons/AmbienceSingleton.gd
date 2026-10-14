extends AudioStreamPlayer3D


const WIND_LIGHT_CALM_SOFT_BREEZE_DEEP_BIG_GUSTY = preload("uid://dt1bxsua66d8j")
var playback_point : float

func _ready() -> void:
	volume_db = -5
	autoplay = true
	
func _enter_tree() -> void:
	stream = WIND_LIGHT_CALM_SOFT_BREEZE_DEEP_BIG_GUSTY
	play(playback_point)
	print(get_tree().root.name)
func _exit_tree() -> void:
	playback_point = get_playback_position()
	print(playback_point)
