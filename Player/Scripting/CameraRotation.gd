extends Node3D

class_name CameraRotation


@onready var pivot: Node3D = $".."

@export var MOUSE_SENS = 0.5
@export var STICK_SENS = 0.05
@export var LOOK_AHEAD_SMOOTHING = .04


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	# Mouse look
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		
func _process(delta: float) -> void:
	# Stick look
	var look_movement = Input.get_vector("lookLeft", "lookRight", "lookDown", "lookUp") * delta
	
	pivot.rotate_y(deg_to_rad(-look_movement.x * STICK_SENS))
	rotate_x(deg_to_rad(look_movement.y * STICK_SENS))
	
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().quit()

	rotation.x = clampf(rotation.x, deg_to_rad(-85), deg_to_rad(55))

	
var previous_value : float
var look_mod = .5
func look_towards_y(value: float, strength: float):
	if value == previous_value:
		look_mod = lerp(look_mod, value, LOOK_AHEAD_SMOOTHING)
	else:
		look_mod = 0.0
		previous_value = value

	pivot.rotation.y += -value * strength * abs(look_mod)
