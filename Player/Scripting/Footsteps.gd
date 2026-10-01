extends AudioStreamPlayer3D

class_name Footsteps


@onready var player_controller: CharacterBody3D = $"../.."

@export var DISTANCE_PER_FOOTSTEP : float = 1
var counter : float

func _physics_process(_delta: float) -> void:
	if !player_controller.is_on_floor():
		return
		
	counter += player_controller.velocity.length()
	
	if counter >= DISTANCE_PER_FOOTSTEP:
		play()
		
		counter = 0
