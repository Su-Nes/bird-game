extends Interactable

class_name Radio


@export var SONG_HOLDER : Node3D

var song_index = 0

func _ready() -> void:
	for song : AudioStreamPlayer3D in SONG_HOLDER.get_children():
		song.volume_linear = 0

func on_use():
	song_index += 1
	
	if song_index > SONG_HOLDER.get_child_count() - 1:
		song_index = 0
	
	var i = 0
	for song : AudioStreamPlayer3D in SONG_HOLDER.get_children():
		song.volume_linear = 1.0 if i == song_index else 0.0
		
	return true
