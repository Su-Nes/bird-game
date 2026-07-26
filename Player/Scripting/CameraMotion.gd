extends Node3D

@onready var pivot: CharacterBody3D = $".."

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
	var look_movement = Input.get_vector("lookLeft", "lookRight", "lookDown", "lookUp")
	
	pivot.rotate_y(deg_to_rad(-look_movement.x * STICK_SENS))
	rotate_x(deg_to_rad(look_movement.y * STICK_SENS))
	
	rotation.x = clamp(rotation.x, deg_to_rad(-85), deg_to_rad(60))
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
