extends State

class_name FireflyFly


@onready var firefly : CharacterBody3D = $"../.."

@export var FLIGHT_SPEED_RANGE : Vector2 = Vector2(.5, 2)
var speed
@export var RAND_ROTATION_RANGE : Vector2 = Vector2(15, 30)
@export var ROTATE_TIME : float = .5
var rotate_timer : float

var lifetime = 0.0

func enter():
	lifetime = 25
	
	state_machine.ANIMATOR.play("Blink")
	
	speed = randf_range(FLIGHT_SPEED_RANGE.x, FLIGHT_SPEED_RANGE.y)
	state_machine.ANIMATOR.speed_scale = randf()
	
	firefly.velocity = random_rot()
	
func physics_update(_delta: float):
	rotate_timer += _delta
	if rotate_timer >= ROTATE_TIME:
		var direction = firefly.velocity.rotated(random_rot(), randf_range(RAND_ROTATION_RANGE.x, RAND_ROTATION_RANGE.y)).normalized()
		var y_rotation = direction.y - firefly.rotation.y
		firefly.velocity = direction * speed * _delta

		firefly.rotate_y(y_rotation)
		
		rotate_timer = 0
		
	firefly.move_and_slide()

	lifetime -= _delta
	if lifetime <= 0:
		firefly.queue_free()
	
func random_rot() -> Vector3:
	return Vector3(randf(), randf(), randf()).normalized()
