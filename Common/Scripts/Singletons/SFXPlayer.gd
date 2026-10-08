extends AudioStreamPlayer3D


func _ready() -> void:
	attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED

func play_clip(clip: AudioStream, volume = 0.0):
	stream = clip
	volume_db = volume
	
	play()
