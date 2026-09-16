extends Interactable

class_name Berry


@export var STAMINA_VALUE : float = 3


func on_interact():
	super.on_lose_focus()
	
	print("Interacted with berry")
	if StatController.regain_max_stamina(STAMINA_VALUE):
		queue_free()
		
func on_use():
	print("Used berry")
	if StatController.regain_max_stamina(STAMINA_VALUE):
		super.on_unselected()
		self.queue_free()

		return false
	else:
		return true
