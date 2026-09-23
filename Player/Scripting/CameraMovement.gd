extends Node3D

class_name CameraMovement


var enabled = true

@onready var pivot: Node3D = $".."
@onready var camera_3d: Camera3D = $CameraSpring/Camera3D

@export var MOUSE_SENS = 0.5
@export var STICK_SENS = 0.05
@export var LOOK_AHEAD_SMOOTHING = .04
@export var CAM_RESET_MOD = .33
@export var SIDE_SWITCH_SENSITIVITY : float = 3
var disable_look_timer: float

var rot_clamped = true
var target_distance : float = 1.5
var target_position : Vector3 = Vector3(0, .7, 0)
var lerp_value : float = .1
var camera_side = 1


func _input(event):
	# Mouse look
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS * get_process_delta_time()))
		rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS * get_process_delta_time()))
		
		disable_look_timer = 0
		
func _process(delta: float):
	# Stick look
	var look_movement = Input.get_vector("lookLeft", "lookRight", "lookDown", "lookUp") * delta
	
	if look_movement.length() > 0:
		disable_look_timer = 0
	
	pivot.rotate_y(deg_to_rad(-look_movement.x * STICK_SENS))
	rotate_x(deg_to_rad(look_movement.y * STICK_SENS))
	
	if rot_clamped:
		rotation.x = clampf(rotation.x, deg_to_rad(-85), deg_to_rad(55))
	
	# Change camera side based on camera and bird angle
	#var flat_camera_forward = get_camera_forward()
	#flat_camera_forward.y = 0
	#var angle = flat_camera_forward.normalized().signed_angle_to(-$"../../Mesh".global_basis.z, Vector3.UP)
#
	#if rad_to_deg(angle) > SIDE_SWITCH_SENSITIVITY:
		#camera_side = -1
	#elif rad_to_deg(angle) < -SIDE_SWITCH_SENSITIVITY:
		#camera_side = 1
	
	position.x = lerp(position.x, abs(target_position.x) * camera_side, lerp_value * delta)
	
	# timer for camera look when moving ze camera
	if !Input.is_action_pressed("alt"): # Disable cam reset
		disable_look_timer += delta
		
	if Input.is_action_just_released("alt"):
		disable_look_timer = 999.0

	
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
	
# To avoid stacking recursion functions

func move_cam(new_spring_dist: float, new_position : Vector3, lerp_strength : float):
	target_position = new_position
	target_distance = new_spring_dist
	lerp_value = lerp_strength
	
	$CameraSpring.spring_length = lerp($CameraSpring.spring_length, new_spring_dist, lerp_strength * get_process_delta_time())
	position.y = lerp(position.y, new_position.y, lerp_strength * get_process_delta_time())
	position.z = lerp(position.z, new_position.z, lerp_strength * get_process_delta_time())
	
	# Recursion! (it's kinda pointless because now I can handle this all in _process but it still works
	if abs(new_spring_dist - $CameraSpring.spring_length) > .05:
		if !get_tree():
			return
		await get_tree().process_frame
		move_cam(target_distance, target_position, lerp_value)
	else: 
		$CameraSpring.spring_length = target_distance
		position.y = target_position.y
		position.z = new_position.z
