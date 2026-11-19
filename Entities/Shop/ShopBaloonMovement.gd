extends AnimatableBody3D

class_name ShopBaloonMovement


@export var SPEED : float = 5
@export var MAX_COLLISION_HEIGHT : float = 1000

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	translate(Vector3.FORWARD * SPEED * delta)
	
	if global_position.y >= MAX_COLLISION_HEIGHT:
		set_collision_layer_value(0, false)
	else:
		set_collision_layer_value(0, true)
