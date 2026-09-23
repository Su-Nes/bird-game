extends State

class_name FishOutOfWater


@onready var fish_rb: RigidBody3D = $"../.."
@onready var MESH : Node3D = $"../../Mesh"

@export var BOUNCE_FORCE : float = 4

func enter():
	state_machine.ANIMATOR.play("Frolic")
	
	MESH.rotation.z = 0
	
	fish_rb.axis_lock_linear_y = false
	fish_rb.axis_lock_angular_x = false
	fish_rb.axis_lock_angular_y = false
	fish_rb.axis_lock_angular_z = false
