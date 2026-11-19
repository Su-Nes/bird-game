extends Interactable

class_name PurchaseBox


@export var ITEM_SCENE : PackedScene

var current_item : Interactable

func _ready() -> void:
	if ITEM_SCENE:
		initiate_item(ITEM_SCENE)

func initiate_item(item: PackedScene):
	if current_item:
		current_item.queue_free()
	
	current_item = item.instantiate()
	add_child(current_item)
	current_item.scale = current_item.DISPLAY_SCALE
	
	$PriceTag/Label3D.text = "%s" % current_item.PRICE
	
func on_interact():
	if StatController.seeds < current_item.PRICE:
		print("Not enough seeds!")
		return
		
	StatController.seeds -= current_item.PRICE
		
	var new_item : Interactable = ITEM_SCENE.instantiate()
	Signals.grab_item.emit(new_item)
	
	$Kaching.play()
