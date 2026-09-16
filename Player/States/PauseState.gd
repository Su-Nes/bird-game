extends State

class_name PauseState


func _ready() -> void:
	MenuManager.has_paused.connect(enter_pause_state)
	MenuManager.has_unpaused.connect(exit_pause_state)

func enter():
	print("Entered Pause state.")

func enter_pause_state():
	state_machine.change_state(name)

func exit_pause_state():
	state_machine.change_state(state_machine.previous_state.name)
