extends Node3D

class_name CameraRotation


@onready var pivot: Node3D = $".."
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D

@export var MOUSE_SENS = 0.5
@export var STICK_SENS = 0.05
@export var LOOK_AHEAD_SMOOTHING = .04
@export var CAM_RESET_MOD = .33
var disable_look_timer: float


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	# Mouse look
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		
		disable_look_timer = 0
		
func _process(delta: float):	
	# Stick look
	var look_movement = Input.get_vector("lookLeft", "lookRight", "lookDown", "lookUp") * delta
	
	if look_movement.length() > 0:
		disable_look_timer = 0
	
	pivot.rotate_y(deg_to_rad(-look_movement.x * STICK_SENS))
	rotate_x(deg_to_rad(look_movement.y * STICK_SENS))
	
	rotation.x = clampf(rotation.x, deg_to_rad(-85), deg_to_rad(55))

	# timer for camera look when moving ze camera
	if !Input.is_action_pressed("alt"): # Disable cam reset
		disable_look_timer += delta
		
	if Input.is_action_just_released("alt"):
		disable_look_timer = 999.0
	
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().quit()

	
var previous_value : float
var look_mod = .5
func look_towards_y(value: float, strength: float, cam_reset_time = .5):
	if disable_look_timer < cam_reset_time:
		return
	
	if value == previous_value:
		look_mod = lerp(look_mod, value, LOOK_AHEAD_SMOOTHING)
	else:
		look_mod = 0.0
		previous_value = value

	pivot.rotation.y += -value * strength * abs(look_mod)
	
func look_towards_vector(direction: Vector3, strength: float, cam_reset_time: float = .5, up: Vector3 = Vector3.UP):
	if disable_look_timer < cam_reset_time:
		strength *= CAM_RESET_MOD
	
	var look_pos = global_position + direction * 999.9

	var start_rot = pivot.rotation
	pivot.transform = pivot.transform.looking_at(look_pos, up)
	var end_rot = pivot.rotation
	pivot.rotation = start_rot
	
	pivot.rotation.y = lerp_angle(pivot.rotation.y, end_rot.y, strength)
	rotation.x = lerp_angle(rotation.x, end_rot.x, strength)
	
func roll(angle: float):
	pivot.rotate_z(angle)
	
func get_camera_forward() -> Vector3:
	return -camera_3d.global_basis.z
	
func get_camera_right() -> Vector3:
	return camera_3d.global_basis.x
