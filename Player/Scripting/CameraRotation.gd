extends Node3D

class_name CameraRotation


@onready var pivot: Node3D = $".."

@export var MOUSE_SENS = 0.5
@export var STICK_SENS = 0.05
@export var LOOK_AHEAD_SMOOTHING = .04
@export var DURATION_LOOK_DISABLED_ON_MOUSE_MOVE = .75
var disable_look_timer = 0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	# Mouse look
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		
		disable_look_timer = DURATION_LOOK_DISABLED_ON_MOUSE_MOVE
		
func _process(delta: float) -> void:	
	# Stick look
	var look_movement = Input.get_vector("lookLeft", "lookRight", "lookDown", "lookUp") * delta
	
	if look_movement.length() > 0:
		disable_look_timer = DURATION_LOOK_DISABLED_ON_MOUSE_MOVE
	
	pivot.rotate_y(deg_to_rad(-look_movement.x * STICK_SENS))
	rotate_x(deg_to_rad(look_movement.y * STICK_SENS))
	
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().quit()

	rotation.x = clampf(rotation.x, deg_to_rad(-85), deg_to_rad(55))
	
	# timer for camera look when moving ze camera
	if disable_look_timer > 0:
		disable_look_timer -= delta

	
var previous_value : float
var look_mod = .5
func look_towards_y(value: float, strength: float):
	if disable_look_timer > 0:
		return
	
	if value == previous_value:
		look_mod = lerp(look_mod, value, LOOK_AHEAD_SMOOTHING)
	else:
		look_mod = 0.0
		previous_value = value

	pivot.rotation.y += -value * strength * abs(look_mod)
	
func look_towards_vector(direction: Vector3, strength):
	if disable_look_timer > 0:
		return
	
	var look_pos = global_position + direction * 99

	var start_rot = pivot.rotation
	pivot.transform = pivot.transform.looking_at(look_pos)
	var end_rot = pivot.rotation

	pivot.rotation.y = lerp_angle(start_rot.y, end_rot.y, strength)
	rotation.x = lerp_angle(rotation.x, end_rot.x, strength)
