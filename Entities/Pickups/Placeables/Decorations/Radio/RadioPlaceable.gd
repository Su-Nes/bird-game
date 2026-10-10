extends Interactable

class_name Radio


@export var SONG_HOLDER : Node3D
@export var SONG_VOLUME : float = -3

var song_index = 0

func _ready() -> void:
	for song : AudioStreamPlayer3D in SONG_HOLDER.get_children():
		song.volume_db = -80
		
	song_index = randi() % SONG_HOLDER.get_child_count()
	on_use()

func on_use():
	song_index += 1
	
	if song_index > SONG_HOLDER.get_child_count() - 1:
		song_index = 0
	
	var i = 0
	for song : AudioStreamPlayer3D in SONG_HOLDER.get_children():
		song.volume_db = SONG_VOLUME if i == song_index else -80.0
		i += 1
		
	return true
