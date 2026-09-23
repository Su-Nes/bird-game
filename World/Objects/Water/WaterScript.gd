extends Area3D

class_name WaterScript


@export var FISH : PackedScene
@export var SPAWN_RATE := Vector2(60, 120)
@export var SPAWN_GROUP := Vector2(3, 7)
@export var SPAWN_RADIUS : float = 25
@export var SPAWN_DEPTH : float = -1.5
@export var MAX_FISH : float = 30

var fish_count : int
var spawn_timer : float

func _process(delta: float) -> void:
	if spawn_timer > 0:
		spawn_timer -= delta
	else:
		spawn_group()
		spawn_timer = randf_range(SPAWN_RATE.x, SPAWN_RATE.y)

func spawn_group():
	var group_size = randf_range(SPAWN_GROUP.x, SPAWN_GROUP.y)
	
	for n in group_size:
		spawn_fish()
		
func spawn_fish():
	if fish_count >= MAX_FISH:
		return
	
	var rand_vector = Vector3.FORWARD.rotated(Vector3.UP, 2 * PI * randf())
	var rand_pos = global_position + rand_vector * SPAWN_RADIUS * randf()
	rand_pos.y += SPAWN_DEPTH

	var new_fish : Node3D = FISH.instantiate()
	add_child(new_fish)
	
	new_fish.rotate_y(2 * PI * randf())
	new_fish.global_position = rand_pos

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.player_change_state.emit("SwimState")
		
	if body.is_in_group("Fish"):
		var fish_machine : StateMachine = body.get_child(0)
		fish_machine.change_state("FishSwim")
		fish_count += 1

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.player_change_state.emit("IdleState")
		
	if body.is_in_group("Fish"):
		fish_count -= 1
