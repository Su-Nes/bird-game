extends Node3D

@onready var pivot: CharacterBody3D = $".."

@export var CAMERA_SENS = 0.003

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
# Mouse look
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * CAMERA_SENS))
		rotate_x(deg_to_rad(-event.relative.y * CAMERA_SENS))
	
	#elif event is InputEventJoypadMotion:
	#	pivot.rotate_y(-event..x * CAMERA_SENS)
	#	pivot.rotate_x(-event.relative.y * CAMERA_SENS)
	
	rotation.x = clamp(rotation.x, deg_to_rad(-85), deg_to_rad(60))
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
