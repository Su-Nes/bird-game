extends Interactable

class_name Edible


@export var STATE_MACHINE : StateMachine
@export var GRABBED_STATE : State
@export var STAMINA_VALUE : float = 3

func on_interact():
	super.on_lose_focus()
	
	if StatController.regain_max_stamina(STAMINA_VALUE):
		queue_free()
		
func on_selected():
	if STATE_MACHINE:
		STATE_MACHINE.change_state(GRABBED_STATE.name)
		
func on_use():
	if StatController.regain_max_stamina(STAMINA_VALUE):
		super.on_unselected()
		self.queue_free()

		return false
	else:
		return true
