extends Interactable

class_name Placeable


func on_focus():
	var tip_kb : Dictionary[Texture2D, String] = {GRAB_ICON_KB : GRAB_TOOL_TIP}
	var tip_gp : Dictionary[Texture2D, String] = {GRAB_ICON_GP : GRAB_TOOL_TIP}

	Signals.display_tool_tips.emit(tip_kb, tip_gp, String.num_int64(interaction_tip_index))

func on_selected():
	super.on_selected()
	#push_error("%s selected" % name)
	Signals.build_controller.initiate_building(self)
	
func on_unselected():
	super.on_unselected()

	Signals.build_controller.stop_building()

func on_use():
	return false if Signals.build_controller.place() else true
