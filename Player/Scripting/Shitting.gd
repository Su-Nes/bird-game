extends Marker3D

class_name Shitting


@onready var player_controller: CharacterBody3D = $".."

@export var SHIT : PackedScene = preload("uid://c56lxpl8igtjw")
@export var SHIT_INTERVAL : Vector2
@export var SHIT_SOUND : AudioStream = preload("uid://xdfj14ah5i7n")

var shit_timer : float
var shit_interval : float

func _process(delta: float) -> void:
	shit_timer += delta
	
	if shit_timer >= shit_interval:
		shit()
		
		shit_timer = 0
		shit_interval = randf_range(SHIT_INTERVAL.x, SHIT_INTERVAL.y)
		
func shit():
	SfxPlayer.play_clip(SHIT_SOUND, -15)
	
	var new_shit : RigidBody3D = SHIT.instantiate()
	get_tree().root.add_child(new_shit)
	
	new_shit.global_position = global_position
	
	new_shit.linear_velocity = player_controller.velocity
