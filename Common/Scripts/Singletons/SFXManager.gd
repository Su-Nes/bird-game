extends Node


func play_clip(clip: AudioStream, position : Vector3, volume = 1.0):
	var player = AudioStreamPlayer3D.new()
	player.stream = clip
	player.volume_db = volume
	
	var new_player = PackedScene.new()
	new_player.pack(player)
	
	var player3D = new_player.instantiate()
	get_tree().root.add_child(player3D)
	
	player3D.global_position = position
	
	player3D.play()
	
	await get_tree().create_timer(clip.get_length()).timeout
	player3D.queue_free()
