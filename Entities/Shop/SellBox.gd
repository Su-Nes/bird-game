extends Interactable

class_name SellBox


@export var SELL_FRACTION : float = .75

var sell_value_label = preload(Constants.SCENE_PATHS.Label3D)

func on_interact():
	if !Signals.grab_controller.get_active_item():
		return
	
	var sold_item : Interactable = Signals.grab_controller.get_active_item()
	var sell_value := roundi(sold_item.PRICE * SELL_FRACTION) 
	
	StatController.seeds += sell_value
	
	var new_label : Label3D = sell_value_label.instantiate()
	add_child(new_label)
	
	new_label.text = "+%s" % sell_value
	new_label.position.y += 1
	
	$gnihcaK.play()
	
	Signals.grab_controller.remove_selected_item()
	sold_item.queue_free()
