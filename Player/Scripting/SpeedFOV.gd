extends Camera3D

class_name SpeedFOV


@export var CONTROLLER : CharacterBody3D
@export var MAX_FOV : float = 120
@export var FOV_CURVE : Curve

var start_fov : float

func _ready() -> void:
	start_fov = fov

func _process(_delta: float) -> void:
	fov = lerp(start_fov, MAX_FOV, FOV_CURVE.sample(CONTROLLER.velocity.length()))
