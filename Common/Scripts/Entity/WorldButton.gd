extends Interactable

class_name WorldButton


signal on_pressed

func on_interact():
	on_pressed.emit()
	
func on_grabbed():
	on_pressed.emit()
