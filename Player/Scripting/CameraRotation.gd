extends Node3D

class_name CameraRotation


@onready var pivot: Node3D = $".."

@export var MOUSE_SENS = 0.5
@export var STICK_SENS = 0.05


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	# Mouse look
	if event is InputEventMouseMotion:
		pivot.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		
func _physics_process(_delta: float) -> void:
	# Stick look
	var look_movement = Input.get_vector("lookLeft", "lookRight", "lookDown", "lookUp")
	
	pivot.rotate_y(deg_to_rad(-look_movement.x * STICK_SENS))
	rotate_x(deg_to_rad(look_movement.y * STICK_SENS))

	
func look_towards(direction: Vector3, weight: float):
	# Smooth look towards move direction
	if direction.length() < 0.01:
		return
	
	
		
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().quit()

	rotation.x = clampf(rotation.x, deg_to_rad(-85), deg_to_rad(55))
