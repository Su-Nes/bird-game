extends Interactable

class_name Edible


@export var STATE_MACHINE : StateMachine
@export var GRABBED_STATE : State
@export var STAMINA_VALUE : float = 3

const EAT_CRUNCHY = preload("uid://j2vgvi3fr4rw")


func on_interact():
	super.on_lose_focus()
	
	eat()

func on_selected():
	if STATE_MACHINE:
		STATE_MACHINE.change_state(GRABBED_STATE.name)

func on_use():
	return eat()

func eat():
	if StatController.regain_max_stamina(STAMINA_VALUE):
		StatController.spend_stamina(-STAMINA_VALUE)
		super.on_unselected()
		queue_free()
		
		SfxPlayer.play_clip(EAT_CRUNCHY, -3)

		return false
	else:
		return true
		
func on_dropped():
	if STATE_MACHINE:
		STATE_MACHINE.change_state(STATE_MACHINE.initial_state.name)
