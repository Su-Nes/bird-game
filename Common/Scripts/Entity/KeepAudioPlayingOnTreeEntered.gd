extends AudioStreamPlayer3D

class_name KeepAudioPlaying


var playback_position : float

func _enter_tree() -> void:
	play(playback_position)
	
func _exit_tree() -> void:
	playback_position = get_playback_position()
