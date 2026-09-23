extends State

class_name FishSwim


@onready var fish_rb: RigidBody3D = $"../.."
@onready var MESH: Node3D = $"../../Mesh"

@export var SWIM_SPEED : float = 10

func enter():
	state_machine.ANIMATOR.play("Swim")
	
	MESH.rotation.z = deg_to_rad(90)
	
	fish_rb.axis_lock_linear_y = true
	fish_rb.axis_lock_angular_x = true
	fish_rb.axis_lock_angular_y = true
	fish_rb.axis_lock_angular_z = true
	
func physics_update(delta: float):
	var collision = fish_rb.move_and_collide(fish_rb.global_basis.z * SWIM_SPEED * delta)
	if collision:
		fish_rb.rotate_y(5)
