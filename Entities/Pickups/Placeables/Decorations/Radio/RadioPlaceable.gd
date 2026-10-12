extends Interactable

class_name Radio


@export var SONG_HOLDER : Node3D
@export var SONG_VOLUME : float = -3

var song_index = 0

func _ready() -> void:
	for song : AudioStreamPlayer3D in SONG_HOLDER.get_children():
		song.volume_db = -80
		
	song_index = randi() % SONG_HOLDER.get_child_count()
	on_use(0)
	
func on_interact():
	on_use()

func on_use(index_step = 1):
	song_index += index_step
	
	if song_index > SONG_HOLDER.get_child_count(): # Intentional so there is one index where all players are set to silent
		song_index = 0
	
	var i = 0
	for song : AudioStreamPlayer3D in SONG_HOLDER.get_children():
		song.volume_db = SONG_VOLUME if i == song_index else -80.0
		i += 1
		
	return true
