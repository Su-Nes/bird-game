extends State

class_name FireflyFly


@onready var firefly : CharacterBody3D = $"../.."

@export var FLIGHT_SPEED_RANGE : Vector2 = Vector2(.5, 2)
var speed
@export var RAND_ROTATION_RANGE : Vector2 = Vector2(15, 30)

var lifetime = 40.0

func enter():
	speed = randf_range(FLIGHT_SPEED_RANGE.x, FLIGHT_SPEED_RANGE.y)
	state_machine.ANIMATOR.speed_scale = randf()
	
	firefly.velocity = random_rot()
	
func physics_update(_delta: float):
	firefly.velocity = firefly.velocity.rotated(random_rot(), randf_range(RAND_ROTATION_RANGE.x, RAND_ROTATION_RANGE.y)).normalized() * speed * _delta
	DebugDraw3D.draw_sphere(firefly.global_position, .5, Color.BLUE)
	firefly.move_and_slide()
	print(firefly.velocity)
	lifetime -= _delta
	if lifetime <= 0:
		firefly.queue_free()
	
func random_rot() -> Vector3:
	return Vector3(randf(), randf(), randf()).normalized()
