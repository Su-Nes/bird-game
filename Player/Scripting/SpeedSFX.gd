extends AudioStreamPlayer3D

class_name SpeedSFX


@onready var player_controller: CharacterBody3D = $"../.."

@export var VOLUME_CURVE : Curve

func _process(_delta: float) -> void:
	volume_db = VOLUME_CURVE.sample(player_controller.velocity.length())
