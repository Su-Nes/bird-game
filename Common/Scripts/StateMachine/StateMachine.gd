extends Node

class_name StateMachine


@export var initial_state : State
@export var ANIMATOR : AnimationPlayer
@export var DEBUG = false

var current_state: State 
var previous_state : State
var states : Dictionary = {}

var stored_vector : Vector3

func _ready() -> void:
	Signals.player_change_state.connect(change_state)
	
	# Register all states in children
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self
			
	if initial_state:
		previous_state = initial_state
		change_state(initial_state.name.to_lower())
	
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
	
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
	
func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
	
func change_state(new_state_name: String) -> void:
	if !states.has(new_state_name.to_lower()):
		return
		
	if DEBUG:
		print("Entered state: %s" % new_state_name)
		
	if current_state:
		previous_state = current_state
		current_state.exit()
		
	current_state = states.get(new_state_name.to_lower())
	
	if current_state:
		current_state.enter()
