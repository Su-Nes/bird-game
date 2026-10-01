extends State

class_name BugWalk


@onready var bug: CharacterBody3D = $"../.."

@export var MOVE_SPEED : float = 5
@export var RAND_DIR_CHANGE := Vector2(1, 3)

var dir_timer : float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func enter():
	state_machine.ANIMATOR.play("Bug")
	

func physics_update(_delta: float):
	bug.velocity = -bug.global_basis.z * MOVE_SPEED * _delta
	bug.velocity.y -= 2
	DebugDraw3D.draw_sphere(bug.global_position, .5, Color.PEACH_PUFF)
	var rot = bug.get_floor_normal()
	rot.y = bug.global_rotation.y
	bug.global_rotation = rot
	
	if dir_timer > 0:
		dir_timer -= _delta
	else:
		bug.rotate_y(randf_range(deg_to_rad(90), deg_to_rad(180)) * 1.0 if randf() > .5 else -1.0)
		dir_timer = randf_range(RAND_DIR_CHANGE.x, RAND_DIR_CHANGE.y)
	
	bug.move_and_slide()
