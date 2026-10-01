extends AudioStreamPlayer3D


func play_clip(clip: AudioStream):
	print(clip.resource_name)
	play()
